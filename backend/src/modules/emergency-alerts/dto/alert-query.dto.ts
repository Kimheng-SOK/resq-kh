import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination.dto';

export class AlertQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ enum: ['active', 'resolved', 'cancelled'] })
  @IsOptional()
  @IsString()
  status?: string;
}
