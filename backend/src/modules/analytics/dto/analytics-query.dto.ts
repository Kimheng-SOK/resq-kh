import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsDateString, IsInt, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';

export class AnalyticsQueryDto {
  @ApiPropertyOptional({ description: 'Start date (ISO 8601)' })
  @IsOptional()
  @IsDateString()
  from?: string;

  @ApiPropertyOptional({ description: 'End date (ISO 8601)' })
  @IsOptional()
  @IsDateString()
  to?: string;

  @ApiPropertyOptional({ enum: ['hour', 'day', 'week', 'month'], default: 'day' })
  @IsOptional()
  @IsString()
  granularity?: 'hour' | 'day' | 'week' | 'month' = 'day';
}

export class ActivityQueryDto {
  @ApiPropertyOptional({ default: 20, minimum: 1, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;

  @ApiPropertyOptional({ enum: ['alert', 'report', 'user', 'notification'] })
  @IsOptional()
  @IsString()
  type?: 'alert' | 'report' | 'user' | 'notification';
}
