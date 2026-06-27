import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AnalyticsController } from './analytics.controller';
import { AnalyticsService } from './analytics.service';
import { EmergencyAlert } from '../emergency-alerts/entities/emergency-alert.entity';
import { EmergencyReport } from '../emergency-reports/entity/emergency-report.entity';
import { User } from '../users/entities/user.entity';
import { UserLocation } from '../user-locations/entities/user-location.entity';
import { Notification } from '../notifications/entities/notification.entity';
import { Service } from '../services/entities/service.entity';
import { EmergencyType } from '../emergency-types/entities/emergency-type.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      EmergencyAlert,
      EmergencyReport,
      User,
      UserLocation,
      Notification,
      Service,
      EmergencyType,
    ]),
  ],
  controllers: [AnalyticsController],
  providers: [AnalyticsService],
  exports: [AnalyticsService],
})
export class AnalyticsModule {}
