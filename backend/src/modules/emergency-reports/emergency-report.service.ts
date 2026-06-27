import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EmergencyReport } from './entity/emergency-report.entity';
import { CreateEmergencyReportDto } from './dto/create-emergency-report.dto';
import { Service } from '../services/entities/service.entity';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class EmergencyReportsService {
  constructor(
    @InjectRepository(EmergencyReport)
    private repo: Repository<EmergencyReport>,

    @InjectRepository(Service)
    private serviceRepo: Repository<Service>,
    private readonly notificationService: NotificationsService,
  ) {}

  async create(dto: CreateEmergencyReportDto) {
    const report = await this.repo.save(this.repo.create(dto));

    const services = await this.serviceRepo.find({
      where: {
        is_active: true,
      },
    });

    for (const service of services) {
      await this.notificationService.createNotification(
        service.id,
        report.id,
        'New Emergency Report',
        report.description ?? 'Emergency reported.',
      );
    }

    return report;
  }

  async findByUser(userId: string) {
    return this.repo.find({
      where: {
        user_id: userId,
      },
      relations: {
        incidentType: true,
      },
      order: {
        created_at: 'DESC',
      },
    });
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