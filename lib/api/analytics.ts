import { api } from '@/lib/api-client';
import type {
  DashboardOverview,
  TimeSeriesPoint,
  StatusBreakdown,
  AlertTypeBreakdown,
  ResponseTimeMetrics,
  ActivityItem,
  AlertMapPoint,
} from './types';

export function getDashboardOverview(): Promise<DashboardOverview> {
  return api.get<DashboardOverview>('/analytics/overview');
}

export function getAlertsTimeSeries(params?: {
  from?: string;
  to?: string;
  granularity?: string;
}): Promise<TimeSeriesPoint[]> {
  return api.get<TimeSeriesPoint[]>(
    '/analytics/alerts/time-series',
    params as Record<string, string>,
  );
}

export function getReportsTimeSeries(params?: {
  from?: string;
  to?: string;
  granularity?: string;
}): Promise<TimeSeriesPoint[]> {
  return api.get<TimeSeriesPoint[]>(
    '/analytics/reports/time-series',
    params as Record<string, string>,
  );
}

export function getUsersTimeSeries(params?: {
  from?: string;
  to?: string;
  granularity?: string;
}): Promise<TimeSeriesPoint[]> {
  return api.get<TimeSeriesPoint[]>(
    '/analytics/users/time-series',
    params as Record<string, string>,
  );
}

export function getAlertsByStatus(): Promise<StatusBreakdown[]> {
  return api.get<StatusBreakdown[]>('/analytics/alerts/by-status');
}

export function getReportsByStatus(): Promise<StatusBreakdown[]> {
  return api.get<StatusBreakdown[]>('/analytics/reports/by-status');
}

export function getAlertsByType(): Promise<AlertTypeBreakdown[]> {
  return api.get<AlertTypeBreakdown[]>('/analytics/alerts/by-type');
}

export function getResponseTime(params?: {
  from?: string;
  to?: string;
}): Promise<ResponseTimeMetrics> {
  return api.get<ResponseTimeMetrics>(
    '/analytics/response-time',
    params as Record<string, string>,
  );
}

export function getRecentActivity(params?: {
  limit?: number;
  type?: string;
}): Promise<ActivityItem[]> {
  return api.get<ActivityItem[]>(
    '/analytics/activity',
    params as Record<string, string>,
  );
}

export function getActiveAlertLocations(): Promise<AlertMapPoint[]> {
  return api.get<AlertMapPoint[]>('/analytics/alerts/map');
}
