import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import {
  EmergencyReport,
  ReportStatus,
} from './entity/emergency-report.entity';
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

  async findAllPaginated(page = 1, limit = 20, status?: string) {
    const where: any = {};
    if (status) where.status = status;

    const [data, total] = await this.repo.findAndCount({
      where,
      relations: { incidentType: true },
      order: { created_at: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    return {
      data,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    };
  }

  async findOne(id: string) {
    const report = await this.repo.findOne({
      where: { id },
      relations: { incidentType: true },
    });
    if (!report) {
      throw new NotFoundException(`Emergency report ${id} not found`);
    }
    return report;
  }

  async updateStatus(id: string, status: ReportStatus) {
    const report = await this.findOne(id);
    report.status = status;
    return this.repo.save(report);
  }

  async remove(id: string) {
    const report = await this.findOne(id);
    await this.repo.remove(report);
    return { deleted: true };
  }
}
