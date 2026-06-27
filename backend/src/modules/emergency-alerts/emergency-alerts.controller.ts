import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import { EmergencyAlertsService } from './emergency-alerts.service';
import { CreateEmergencyAlertDto } from './dto/create-emergency-alert.dto';
import { UpdateAlertStatusDto } from './dto/update-alert-status.dto';
import { AlertQueryDto } from './dto/alert-query.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { AdminRole } from '../admins/entities/admin.entity';

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

  @Get('paginated')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR, AdminRole.VIEWER)
  @ApiBearerAuth()
  findAllPaginated(@Query() query: AlertQueryDto) {
    return this.emergencyAlertsService.findAllPaginated(
      query.page,
      query.limit,
      query.status,
    );
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.emergencyAlertsService.findOne(id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR)
  @ApiBearerAuth()
  updateStatus(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateAlertStatusDto,
  ) {
    return this.emergencyAlertsService.updateStatus(id, dto);
  }
}
