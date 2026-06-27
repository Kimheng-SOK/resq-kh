import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';

import {
  Notification,
  NotificationType,
} from './entities/notification.entity';
import { QueryNotificationDto } from './dto/query-notification.dto';
import { SendNotificationDto } from './dto/send-notification.dto';

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
      type: NotificationType.REPORT_ALERT,
    });

    return this.repo.save(notification);
  }

  // ── Admin: send notification to user(s) ──

  async sendToUsers(dto: SendNotificationDto) {
    const notifications = dto.userIds.map((userId) =>
      this.repo.create({
        user_id: userId,
        title: dto.title,
        body: dto.body,
        type: dto.broadcast
          ? NotificationType.ADMIN_BROADCAST
          : NotificationType.ADMIN_DIRECT,
      }),
    );

    return this.repo.save(notifications);
  }

  // ── List notifications ──

  async findAll(query: QueryNotificationDto) {
    const where: any = {};

    if (query.serviceId) {
      where.service_id = query.serviceId;
    }
    if (query.userId) {
      where.user_id = query.userId;
    }
    if (query.type) {
      where.type = query.type;
    }

    return this.repo.find({
      where,
      relations: { report: true, user: true },
      order: { created_at: 'DESC' },
    });
  }

  async findOne(id: string) {
    const notification = await this.repo.findOne({
      where: { id },
      relations: { report: true, user: true },
    });
    if (!notification) {
      throw new NotFoundException(`Notification ${id} not found`);
    }
    return notification;
  }

  async markRead(id: string) {
    const notification = await this.findOne(id);
    notification.is_read = true;
    return this.repo.save(notification);
  }
}
