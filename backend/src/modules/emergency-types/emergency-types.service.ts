import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EmergencyType } from './entities/emergency-type.entity';
import { CreateEmergencyTypeDto } from './dto/create-emergency-type.dto';
import { UpdateEmergencyTypeDto } from './dto/update-emergency-type.dto';

@Injectable()
export class EmergencyTypesService {
  constructor(
    @InjectRepository(EmergencyType)
    private emergencyTypeRepository: Repository<EmergencyType>,
  ) {}

  findAll(activeOnly = true) {
    return this.emergencyTypeRepository.find({
      where: activeOnly ? { is_active: true } : {},
      order: { sort_order: 'ASC' },
    });
  }

  async findOne(id: string) {
    const type = await this.emergencyTypeRepository.findOne({ where: { id } });
    if (!type) {
      throw new NotFoundException(`Emergency type ${id} not found`);
    }
    return type;
  }

  create(dto: CreateEmergencyTypeDto) {
    const type = this.emergencyTypeRepository.create(dto);
    return this.emergencyTypeRepository.save(type);
  }

  async update(id: string, dto: UpdateEmergencyTypeDto) {
    const type = await this.findOne(id);
    Object.assign(type, dto);
    return this.emergencyTypeRepository.save(type);
  }

  async remove(id: string) {
    const type = await this.findOne(id);
    await this.emergencyTypeRepository.remove(type);
    return { deleted: true };
  }
}
