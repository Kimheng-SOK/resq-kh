import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { ApiQuery, ApiTags } from '@nestjs/swagger';
import { EmergencyAlertsService } from './emergency-alerts.service';
import { CreateEmergencyAlertDto } from './dto/create-emergency-alert.dto';
import { UpdateAlertStatusDto } from './dto/update-alert-status.dto';

@ApiTags('emergency-alerts')
@Controller('emergency-alerts')
export class EmergencyAlertsController {
  constructor(private readonly emergencyAlertsService: EmergencyAlertsService) {}

  @Post()
  create(@Body() dto: CreateEmergencyAlertDto) {
    return this.emergencyAlertsService.create(dto);
  }

  @Get()
  @ApiQuery({ name: 'userId', required: false })
  findAll(@Query('userId') userId?: string) {
    return this.emergencyAlertsService.findAll(userId);
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.emergencyAlertsService.findOne(id);
  }

  @Patch(':id')
  updateStatus(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateAlertStatusDto,
  ) {
    return this.emergencyAlertsService.updateStatus(id, dto);
  }
}
