import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Service } from './entities/service.entity';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';
import { QueryServiceDto } from './dto/query-service.dto';

@Injectable()
export class ServicesService {
  constructor(
    @InjectRepository(Service)
    private serviceRepository: Repository<Service>,
  ) {}

  private toDecimal(value?: number): string | null {
    return value !== undefined && value !== null ? String(value) : null;
  }

  private haversineKm(
    lat1: number,
    lng1: number,
    lat2: number,
    lng2: number,
  ): number {
    const R = 6371;
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLng = ((lng2 - lng1) * Math.PI) / 180;
    const a =
      Math.sin(dLat / 2) ** 2 +
      Math.cos((lat1 * Math.PI) / 180) *
        Math.cos((lat2 * Math.PI) / 180) *
        Math.sin(dLng / 2) ** 2;
    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  }

  async findAll(query: QueryServiceDto) {
    const qb = this.serviceRepository
      .createQueryBuilder('service')
      .where('service.is_active = :active', { active: true });

    if (query.category) {
      qb.andWhere('service.category = :category', { category: query.category });
    }

    let services = await qb.getMany();

    if (query.lat !== undefined && query.lng !== undefined) {
      const radius = query.radius ?? 10;
      services = services
        .map((s) => ({
          ...s,
          distance_km:
            s.latitude && s.longitude
              ? this.haversineKm(
                  query.lat!,
                  query.lng!,
                  parseFloat(s.latitude),
                  parseFloat(s.longitude),
                )
              : null,
        }))
        .filter((s) => s.distance_km === null || s.distance_km <= radius)
        .sort(
          (a, b) =>
            (a.distance_km ?? Infinity) - (b.distance_km ?? Infinity),
        );
    }

    return services;
  }

  async findOne(id: string) {
    const service = await this.serviceRepository.findOne({ where: { id } });
    if (!service) {
      throw new NotFoundException(`Service ${id} not found`);
    }
    return service;
  }

  async create(dto: CreateServiceDto) {
    const service = this.serviceRepository.create({
      ...dto,
      latitude: this.toDecimal(dto.latitude),
      longitude: this.toDecimal(dto.longitude),
    });
    return this.serviceRepository.save(service);
  }

  async update(id: string, dto: UpdateServiceDto) {
    const service = await this.findOne(id);
    if (dto.latitude !== undefined) {
      service.latitude = this.toDecimal(dto.latitude);
    }
    if (dto.longitude !== undefined) {
      service.longitude = this.toDecimal(dto.longitude);
    }
    const { latitude, longitude, ...rest } = dto;
    Object.assign(service, rest);
    return this.serviceRepository.save(service);
  }

  async remove(id: string) {
    const service = await this.findOne(id);
    await this.serviceRepository.remove(service);
    return { deleted: true };
  }
}
