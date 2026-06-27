import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination.dto';

export class ReportQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ enum: ['pending', 'dispatched', 'resolved'] })
  @IsOptional()
  @IsString()
  status?: string;
}
