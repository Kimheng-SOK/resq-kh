import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { EmergencyAlert, EmergencyAlertStatus } from '../emergency-alerts/entities/emergency-alert.entity';
import { EmergencyReport, ReportStatus } from '../emergency-reports/entity/emergency-report.entity';
import { User } from '../users/entities/user.entity';
import { UserLocation } from '../user-locations/entities/user-location.entity';
import { Notification } from '../notifications/entities/notification.entity';
import { Service } from '../services/entities/service.entity';
import { EmergencyType } from '../emergency-types/entities/emergency-type.entity';

@Injectable()
export class AnalyticsService {
  constructor(
    @InjectRepository(EmergencyAlert)
    private alertRepo: Repository<EmergencyAlert>,

    @InjectRepository(EmergencyReport)
    private reportRepo: Repository<EmergencyReport>,

    @InjectRepository(User)
    private userRepo: Repository<User>,

    @InjectRepository(UserLocation)
    private locationRepo: Repository<UserLocation>,

    @InjectRepository(Notification)
    private notificationRepo: Repository<Notification>,

    @InjectRepository(Service)
    private serviceRepo: Repository<Service>,

    @InjectRepository(EmergencyType)
    private emergencyTypeRepo: Repository<EmergencyType>,
  ) {}

  // ── Dashboard Overview ──

  async getDashboardOverview() {
    const [
      totalUsers,
      activeAlerts,
      pendingReports,
      totalServices,
      servicesByCategory,
      notificationCounts,
      newUsersThisWeek,
      newUsersLastWeek,
      alertsThisWeek,
      alertsLastWeek,
    ] = await Promise.all([
      this.userRepo.count(),
      this.alertRepo.count({ where: { status: EmergencyAlertStatus.ACTIVE } }),
      this.reportRepo.count({ where: { status: ReportStatus.PENDING } }),
      this.serviceRepo.count({ where: { is_active: true } }),

      // Services by category
      this.serviceRepo
        .createQueryBuilder('s')
        .select('s.category', 'category')
        .addSelect('COUNT(*)', 'count')
        .where('s.is_active = :active', { active: true })
        .groupBy('s.category')
        .getRawMany<{ category: string; count: string }>(),

      // Notification counts
      this.notificationRepo
        .createQueryBuilder('n')
        .select('COUNT(*)', 'total')
        .addSelect('SUM(CASE WHEN n.is_read = false THEN 1 ELSE 0 END)', 'unread')
        .getRawOne<{ total: string; unread: string }>(),

      // New users this week
      this.userRepo
        .createQueryBuilder('u')
        .where("u.created_at >= DATE_TRUNC('week', CURRENT_DATE)")
        .getCount(),

      // New users last week
      this.userRepo
        .createQueryBuilder('u')
        .where("u.created_at >= DATE_TRUNC('week', CURRENT_DATE - INTERVAL '7 days')")
        .andWhere("u.created_at < DATE_TRUNC('week', CURRENT_DATE)")
        .getCount(),

      // Alerts this week
      this.alertRepo
        .createQueryBuilder('a')
        .where("a.created_at >= DATE_TRUNC('week', CURRENT_DATE)")
        .getCount(),

      // Alerts last week
      this.alertRepo
        .createQueryBuilder('a')
        .where("a.created_at >= DATE_TRUNC('week', CURRENT_DATE - INTERVAL '7 days')")
        .andWhere("a.created_at < DATE_TRUNC('week', CURRENT_DATE)")
        .getCount(),
    ]);

    const total = notificationCounts ? parseInt(notificationCounts.total, 10) : 0;
    const unread = notificationCounts ? parseInt(notificationCounts.unread, 10) : 0;

    return {
      totalUsers,
      activeAlerts,
      pendingReports,
      totalServices,
      servicesByCategory: servicesByCategory.map((s) => ({
        category: s.category,
        count: parseInt(s.count, 10),
      })),
      totalNotifications: total,
      unreadNotifications: unread,
      recentTrends: {
        newUsersThisWeek,
        newUsersLastWeek,
        alertsThisWeek,
        alertsLastWeek,
      },
    };
  }

  // ── Time Series Helpers ──

  private buildTimeSeries(
    qb: SelectQueryBuilder<any>,
    tableAlias: string,
    column: string,
    granularity: string,
    from?: string,
    to?: string,
  ) {
    let dateExpr: string;
    switch (granularity) {
      case 'hour':
        dateExpr = `DATE_TRUNC('hour', ${tableAlias}.${column})`;
        break;
      case 'week':
        dateExpr = `DATE_TRUNC('week', ${tableAlias}.${column})`;
        break;
      case 'month':
        dateExpr = `DATE_TRUNC('month', ${tableAlias}.${column})`;
        break;
      case 'day':
      default:
        dateExpr = `DATE(${tableAlias}.${column})`;
        break;
    }

    qb.select(dateExpr, 'period')
      .addSelect('COUNT(*)', 'count')
      .groupBy('period')
      .orderBy('period', 'ASC');

    if (from) {
      qb.andWhere(`${tableAlias}.${column} >= :from`, { from });
    }
    if (to) {
      qb.andWhere(`${tableAlias}.${column} <= :to`, { to });
    }

    return qb;
  }

  // ── Alert Time Series ──

  async getAlertsTimeSeries(from?: string, to?: string, granularity = 'day') {
    const qb = this.alertRepo.createQueryBuilder('a');
    this.buildTimeSeries(qb, 'a', 'created_at', granularity, from, to);
    return qb.getRawMany<{ period: string; count: string }>();
  }

  // ── Report Time Series ──

  async getReportsTimeSeries(from?: string, to?: string, granularity = 'day') {
    const qb = this.reportRepo.createQueryBuilder('r');
    this.buildTimeSeries(qb, 'r', 'created_at', granularity, from, to);
    return qb.getRawMany<{ period: string; count: string }>();
  }

  // ── New Users Time Series ──

  async getNewUsersTimeSeries(from?: string, to?: string, granularity = 'day') {
    const qb = this.userRepo.createQueryBuilder('u');
    this.buildTimeSeries(qb, 'u', 'created_at', granularity, from, to);
    return qb.getRawMany<{ period: string; count: string }>();
  }

  // ── Alerts by Status ──

  async getAlertsByStatus() {
    return this.alertRepo
      .createQueryBuilder('a')
      .select('a.status', 'status')
      .addSelect('COUNT(*)', 'count')
      .groupBy('a.status')
      .getRawMany<{ status: string; count: string }>();
  }

  // ── Reports by Status ──

  async getReportsByStatus() {
    return this.reportRepo
      .createQueryBuilder('r')
      .select('r.status', 'status')
      .addSelect('COUNT(*)', 'count')
      .groupBy('r.status')
      .getRawMany<{ status: string; count: string }>();
  }

  // ── Alerts by Emergency Type ──

  async getAlertsByEmergencyType() {
    return this.alertRepo
      .createQueryBuilder('a')
      .leftJoin('a.emergency_type', 'et')
      .select('et.id', 'typeId')
      .addSelect('et.label', 'label')
      .addSelect('et.color', 'color')
      .addSelect('COUNT(*)', 'count')
      .groupBy('et.id')
      .addGroupBy('et.label')
      .addGroupBy('et.color')
      .getRawMany<{ typeId: string; label: string; color: string; count: string }>();
  }

  // ── Average Response Time ──

  async getAverageResponseTime(from?: string, to?: string) {
    const qb = this.alertRepo
      .createQueryBuilder('a')
      .select(
        "AVG(EXTRACT(EPOCH FROM (a.resolved_at - a.created_at)) / 60)",
        'averageMinutes',
      )
      .where('a.status = :status', { status: EmergencyAlertStatus.RESOLVED })
      .andWhere('a.resolved_at IS NOT NULL');

    if (from) {
      qb.andWhere('a.created_at >= :from', { from });
    }
    if (to) {
      qb.andWhere('a.created_at <= :to', { to });
    }

    const overall = await qb.getRawOne<{ averageMinutes: string }>();

    // By emergency type
    const byTypeQb = this.alertRepo
      .createQueryBuilder('a')
      .leftJoin('a.emergency_type', 'et')
      .select('et.id', 'typeId')
      .addSelect('et.label', 'label')
      .addSelect(
        "AVG(EXTRACT(EPOCH FROM (a.resolved_at - a.created_at)) / 60)",
        'averageMinutes',
      )
      .where('a.status = :status', { status: EmergencyAlertStatus.RESOLVED })
      .andWhere('a.resolved_at IS NOT NULL')
      .groupBy('et.id')
      .addGroupBy('et.label');

    if (from) {
      byTypeQb.andWhere('a.created_at >= :from', { from });
    }
    if (to) {
      byTypeQb.andWhere('a.created_at <= :to', { to });
    }

    const byType = await byTypeQb.getRawMany<{
      typeId: string;
      label: string;
      averageMinutes: string;
    }>();

    return {
      averageMinutes: overall?.averageMinutes
        ? parseFloat(overall.averageMinutes)
        : 0,
      byType: byType.map((t) => ({
        typeId: t.typeId,
        label: t.label,
        averageMinutes: parseFloat(t.averageMinutes),
      })),
    };
  }

  // ── Recent Activity ──

  async getRecentActivity(limit = 20, type?: string) {
    const queries: Promise<any[]>[] = [];

    if (!type || type === 'alert') {
      queries.push(
        this.alertRepo
          .find({
            relations: { user: true, emergency_type: true },
            order: { created_at: 'DESC' },
            take: limit,
          })
          .then((alerts) =>
            alerts.map((a) => ({
              id: a.id,
              type: 'alert' as const,
              description: `${a.user?.full_name || a.user?.phone_number || 'A user'} reported ${a.emergency_type?.label || 'an emergency'}`,
              status: a.status,
              timestamp: a.created_at,
              relatedId: a.id,
            })),
          ),
      );
    }

    if (!type || type === 'report') {
      queries.push(
        this.reportRepo
          .find({
            relations: { incidentType: true },
            order: { created_at: 'DESC' },
            take: limit,
          })
          .then((reports) =>
            reports.map((r) => ({
              id: r.id,
              type: 'report' as const,
              description: `${r.reporter_name} reported ${r.incidentType?.label || 'an incident'}`,
              status: r.status,
              timestamp: r.created_at,
              relatedId: r.id,
            })),
          ),
      );
    }

    if (!type || type === 'user') {
      queries.push(
        this.userRepo
          .find({
            order: { created_at: 'DESC' },
            take: limit,
          })
          .then((users) =>
            users.map((u) => ({
              id: u.id,
              type: 'user' as const,
              description: `${u.full_name || u.email || u.phone_number || 'A new user'} registered`,
              status: 'new',
              timestamp: u.created_at,
              relatedId: u.id,
            })),
          ),
      );
    }

    if (!type || type === 'notification') {
      queries.push(
        this.notificationRepo
          .find({
            relations: { service: true },
            order: { created_at: 'DESC' },
            take: limit,
          })
          .then((notifications) =>
            notifications.map((n) => ({
              id: n.id,
              type: 'notification' as const,
              description: n.title || 'Notification sent',
              status: n.is_read ? 'read' : 'unread',
              timestamp: n.created_at,
              relatedId: n.emergency_report_id,
            })),
          ),
      );
    }

    const results = (await Promise.all(queries)).flat();

    return results
      .sort(
        (a, b) =>
          new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime(),
      )
      .slice(0, limit);
  }

  // ── Active Alert Locations ──

  async getActiveAlertLocations() {
    const alerts = await this.alertRepo.find({
      where: { status: EmergencyAlertStatus.ACTIVE },
      relations: { location: true, emergency_type: true },
    });

    return alerts
      .filter((a) => a.location?.latitude && a.location?.longitude)
      .map((a) => ({
        id: a.id,
        lat: parseFloat(a.location.latitude),
        lng: parseFloat(a.location.longitude),
        type: a.emergency_type?.label || 'Unknown',
      }));
  }
}
