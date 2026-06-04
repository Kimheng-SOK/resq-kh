import { ApiProperty } from '@nestjs/swagger';
import { IsString, MaxLength } from 'class-validator';

export class VerifyOtpDto {
  @ApiProperty()
  @IsString()
  @MaxLength(50)
  phone_number!: string;

  @ApiProperty()
  @IsString()
  @MaxLength(10)
  otp!: string;
}