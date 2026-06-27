import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import * as bcrypt from 'bcryptjs';
import { Repository } from 'typeorm';
import { Admin } from './entities/admin.entity';
import { CreateAdminDto } from './dto/create-admin.dto';
import { UpdateAdminDto } from './dto/update-admin.dto';

@Injectable()
export class AdminsService {
  constructor(
    @InjectRepository(Admin)
    private adminRepository: Repository<Admin>,
  ) {}

  findAll() {
    return this.adminRepository.find({ order: { created_at: 'DESC' } });
  }

  async findOne(id: string) {
    const admin = await this.adminRepository.findOne({ where: { id } });
    if (!admin) {
      throw new NotFoundException(`Admin ${id} not found`);
    }
    return admin;
  }

  async create(dto: CreateAdminDto) {
    const password = await bcrypt.hash(dto.password, 10);
    const admin = this.adminRepository.create({
      ...dto,
      password,
    });
    return this.adminRepository.save(admin);
  }

  async update(id: string, dto: UpdateAdminDto) {
    const admin = await this.findOne(id);
    if (dto.password) {
      admin.password = await bcrypt.hash(dto.password, 10);
    }
    const { password, ...rest } = dto;
    Object.assign(admin, rest);
    return this.adminRepository.save(admin);
  }

  async remove(id: string) {
    const admin = await this.findOne(id);
    await this.adminRepository.remove(admin);
    return { deleted: true };
  }
}
