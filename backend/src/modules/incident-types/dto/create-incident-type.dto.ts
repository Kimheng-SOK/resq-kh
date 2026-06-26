import { IsString, IsOptional, IsInt, IsNotEmpty } from 'class-validator';

export class CreateIncidentTypeDto {
  @IsString()
  @IsNotEmpty()
  slug: string;

  @IsString()
  @IsNotEmpty()
  label: string;

  @IsString()
  @IsNotEmpty()
  icon_name: string;

  @IsOptional()
  @IsInt()
  sort_order?: number;

  @IsOptional()
  @IsString()
  recommended_responder?: string;
}