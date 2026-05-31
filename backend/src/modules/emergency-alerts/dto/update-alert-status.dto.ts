import { ApiProperty } from '@nestjs/swagger';
import { IsEnum } from 'class-validator';
import { EmergencyAlertStatus } from '../entities/emergency-alert.entity';

export class UpdateAlertStatusDto {
  @ApiProperty({ enum: EmergencyAlertStatus })
  @IsEnum(EmergencyAlertStatus)
  status: EmergencyAlertStatus;
}
