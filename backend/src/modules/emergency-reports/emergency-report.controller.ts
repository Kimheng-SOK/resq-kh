import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { EmergencyReportsService } from './emergency-report.service';
import { CreateEmergencyReportDto } from './dto/create-emergency-report.dto';

@ApiTags('emergency-reports')
@Controller('emergency-reports')
export class EmergencyReportsController {
  constructor(private readonly service: EmergencyReportsService) {}

  @Post()
  create(@Body() dto: CreateEmergencyReportDto) {
    return this.service.create(dto);
  }

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.service.findOne(id);
  }
  
  @Get('user/:userId')
  findByUser(@Param('userId') userId: string) {
    return this.service.findByUser(userId);
  }

}