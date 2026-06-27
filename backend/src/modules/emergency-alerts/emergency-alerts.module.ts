import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EmergencyAlert } from './entities/emergency-alert.entity';
import { UserLocation } from '../user-locations/entities/user-location.entity';
import { Notification } from '../notifications/entities/notification.entity';
import { UsersModule } from '../users/users.module';
import { EmergencyTypesModule } from '../emergency-types/emergency-types.module';
import { EmergencyAlertsController } from './emergency-alerts.controller';
import { EmergencyAlertsService } from './emergency-alerts.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([EmergencyAlert, UserLocation, Notification]),
    UsersModule,
    EmergencyTypesModule,
  ],
  controllers: [EmergencyAlertsController],
  providers: [EmergencyAlertsService],
})
export class EmergencyAlertsModule {}
