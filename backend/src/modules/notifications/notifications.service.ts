import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Notification } from './entities/notification.entity';
import { QueryNotificationDto } from './dto/query-notification.dto';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(Notification)
    private readonly repo: Repository<Notification>,
  ) {}

  async createNotification(
    serviceId: string,
    reportId: string,
    title: string,
    body: string,
  ) {
    const notification = this.repo.create({
      service_id: serviceId,
      emergency_report_id: reportId,
      title,
      body,
    });

    return this.repo.save(notification);
  }

  async findAll(query: QueryNotificationDto) {
    return this.repo.find({
      where: {
        service_id: query.serviceId,
      },
      relations: {
        report: true,
      },
      order: {
        created_at: 'DESC',
      },
    });
  }

  async markRead(id: string) {
    const notification = await this.repo.findOne({
      where: { id },
    });

    if (!notification) {
      throw new NotFoundException();
    }

    notification.is_read = true;

    return this.repo.save(notification);
  }
}