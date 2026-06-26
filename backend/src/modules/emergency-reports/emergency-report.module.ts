import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EmergencyReport } from './entity/emergency-report.entity';
import { EmergencyReportsService } from './emergency-report.service';
import { EmergencyReportsController } from './emergency-report.controller';
import { Service } from '../services/entities/service.entity';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [TypeOrmModule.forFeature([EmergencyReport, Service]), NotificationsModule],
  controllers: [EmergencyReportsController],
  providers: [EmergencyReportsService],
})
export class EmergencyReportsModule {}