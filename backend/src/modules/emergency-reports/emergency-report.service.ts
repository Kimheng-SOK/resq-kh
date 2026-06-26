import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EmergencyReport } from './entity/emergency-report.entity';
import { CreateEmergencyReportDto } from './dto/create-emergency-report.dto';

@Injectable()
export class EmergencyReportsService {
  constructor(
    @InjectRepository(EmergencyReport)
    private repo: Repository<EmergencyReport>,
  ) {}

  create(dto: CreateEmergencyReportDto) {
    const report = this.repo.create(dto);
    return this.repo.save(report);
  }

  findAll() {
    return this.repo.find({
      relations: { incidentType: true },
      order: { created_at: 'DESC' },
    });
  }

  findOne(id: string) {
    return this.repo.findOne({
      where: { id },
      relations: { incidentType: true },
    });
  }
}