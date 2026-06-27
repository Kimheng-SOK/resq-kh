import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserLocation } from './entities/user-location.entity';
import { CreateUserLocationDto } from './dto/create-user-location.dto';
import { UsersService } from '../users/users.service';

@Injectable()
export class UserLocationsService {
  constructor(
    @InjectRepository(UserLocation)
    private locationRepository: Repository<UserLocation>,
    private usersService: UsersService,
  ) {}

  async create(dto: CreateUserLocationDto) {
    await this.usersService.findOne(dto.user_id);
    const location = this.locationRepository.create({
      user_id: dto.user_id,
      latitude: String(dto.latitude),
      longitude: String(dto.longitude),
      accuracy: dto.accuracy !== undefined ? String(dto.accuracy) : null,
      captured_at: new Date(),
    });
    return this.locationRepository.save(location);
  }

  async findAll(userId: string) {
    await this.usersService.findOne(userId);
    return this.locationRepository.find({
      where: { user_id: userId },
      order: { captured_at: 'DESC' },
    });
  }
}
