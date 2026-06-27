import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class QueryNotificationDto {
  @ApiProperty()
  @IsUUID()
  serviceId?: string;
}