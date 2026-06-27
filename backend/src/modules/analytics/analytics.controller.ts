import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AnalyticsService } from './analytics.service';
import { AnalyticsQueryDto, ActivityQueryDto } from './dto/analytics-query.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { AdminRole } from '../admins/entities/admin.entity';

@ApiTags('analytics')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR, AdminRole.VIEWER)
@Controller('analytics')
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('overview')
  getOverview() {
    return this.analyticsService.getDashboardOverview();
  }

  @Get('alerts/time-series')
  getAlertsTimeSeries(@Query() query: AnalyticsQueryDto) {
    return this.analyticsService.getAlertsTimeSeries(
      query.from,
      query.to,
      query.granularity,
    );
  }

  @Get('reports/time-series')
  getReportsTimeSeries(@Query() query: AnalyticsQueryDto) {
    return this.analyticsService.getReportsTimeSeries(
      query.from,
      query.to,
      query.granularity,
    );
  }

  @Get('users/time-series')
  getUsersTimeSeries(@Query() query: AnalyticsQueryDto) {
    return this.analyticsService.getNewUsersTimeSeries(
      query.from,
      query.to,
      query.granularity,
    );
  }

  @Get('alerts/by-status')
  getAlertsByStatus() {
    return this.analyticsService.getAlertsByStatus();
  }

  @Get('reports/by-status')
  getReportsByStatus() {
    return this.analyticsService.getReportsByStatus();
  }

  @Get('alerts/by-type')
  getAlertsByType() {
    return this.analyticsService.getAlertsByEmergencyType();
  }

  @Get('response-time')
  getResponseTime(@Query('from') from?: string, @Query('to') to?: string) {
    return this.analyticsService.getAverageResponseTime(from, to);
  }

  @Get('activity')
  getRecentActivity(@Query() query: ActivityQueryDto) {
    return this.analyticsService.getRecentActivity(query.limit, query.type);
  }

  @Get('alerts/map')
  getAlertLocations() {
    return this.analyticsService.getActiveAlertLocations();
  }
}
