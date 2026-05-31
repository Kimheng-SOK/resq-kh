import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/pagination.dto';

export class QueryNotificationDto extends PaginationQueryDto {
  @ApiProperty()
  @IsUUID()
  userId: string;
}
