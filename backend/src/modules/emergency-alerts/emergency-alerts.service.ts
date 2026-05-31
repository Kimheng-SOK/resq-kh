import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import {
  EmergencyAlert,
  EmergencyAlertStatus,
} from './entities/emergency-alert.entity';
import { UserLocation } from '../user-locations/entities/user-location.entity';
import { Notification, NotificationType } from '../notifications/entities/notification.entity';
import { CreateEmergencyAlertDto } from './dto/create-emergency-alert.dto';
import { UpdateAlertStatusDto } from './dto/update-alert-status.dto';
import { UsersService } from '../users/users.service';
import { EmergencyTypesService } from '../emergency-types/emergency-types.service';

@Injectable()
export class EmergencyAlertsService {
  constructor(
    @InjectRepository(EmergencyAlert)
    private alertRepository: Repository<EmergencyAlert>,
    @InjectRepository(UserLocation)
    private locationRepository: Repository<UserLocation>,
    @InjectRepository(Notification)
    private notificationRepository: Repository<Notification>,
    private usersService: UsersService,
    private emergencyTypesService: EmergencyTypesService,
  ) {}

  async findAll(userId?: string) {
    const where = userId ? { user_id: userId } : {};
    return this.alertRepository.find({
      where,
      relations: { emergency_type: true, location: true, user: true },
      order: { created_at: 'DESC' },
    });
  }

  async findOne(id: string) {
    const alert = await this.alertRepository.findOne({
      where: { id },
      relations: { emergency_type: true, location: true, user: true },
    });
    if (!alert) {
      throw new NotFoundException(`Emergency alert ${id} not found`);
    }
    return alert;
  }

  async create(dto: CreateEmergencyAlertDto) {
    await this.usersService.findOne(dto.user_id);
    const emergencyType = await this.emergencyTypesService.findOne(
      dto.emergency_type_id,
    );

    const location = this.locationRepository.create({
      user_id: dto.user_id,
      latitude: String(dto.latitude),
      longitude: String(dto.longitude),
      accuracy: dto.accuracy !== undefined ? String(dto.accuracy) : null,
      captured_at: new Date(),
    });
    const savedLocation = await this.locationRepository.save(location);

    const alert = this.alertRepository.create({
      user_id: dto.user_id,
      emergency_type_id: dto.emergency_type_id,
      location_id: savedLocation.id,
      notes: dto.notes ?? null,
      status: EmergencyAlertStatus.ACTIVE,
    });
    const savedAlert = await this.alertRepository.save(alert);

    await this.notificationRepository.save(
      this.notificationRepository.create({
        user_id: dto.user_id,
        emergency_alert_id: savedAlert.id,
        type: NotificationType.SOS,
        title: 'SOS Alert Triggered',
        body: `Emergency alert (${emergencyType.label}) has been activated.`,
      }),
    );

    return this.findOne(savedAlert.id);
  }

  async updateStatus(id: string, dto: UpdateAlertStatusDto) {
    const alert = await this.findOne(id);
    alert.status = dto.status;
    if (
      dto.status === EmergencyAlertStatus.RESOLVED ||
      dto.status === EmergencyAlertStatus.CANCELLED
    ) {
      alert.resolved_at = new Date();
    }
    return this.alertRepository.save(alert);
  }
}
