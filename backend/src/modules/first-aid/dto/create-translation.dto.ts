import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsUUID, MaxLength } from 'class-validator';

export class CreateTopicTranslationDto {
  @ApiProperty()
  @IsUUID()
  topic_id: string;

  @ApiProperty({ example: 'en' })
  @IsString()
  @MaxLength(10)
  language_code: string;

  @ApiProperty()
  @IsString()
  @MaxLength(255)
  title: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  summary?: string;
}

export class CreateStepTranslationDto {
  @ApiProperty()
  @IsUUID()
  step_id: string;

  @ApiProperty({ example: 'en' })
  @IsString()
  @MaxLength(10)
  language_code: string;

  @ApiProperty()
  @IsString()
  instruction: string;
}
