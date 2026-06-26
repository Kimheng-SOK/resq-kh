import { IsString, IsOptional, IsNumber, IsUUID, IsNotEmpty } from 'class-validator';

export class CreateEmergencyReportDto {
  @IsUUID()
  incident_type_id: string;

  @IsString()
  @IsNotEmpty()
  reporter_name: string;

  @IsString()
  @IsNotEmpty()
  reporter_phone: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  latitude?: number;

  @IsOptional()
  @IsNumber()
  longitude?: number;
}