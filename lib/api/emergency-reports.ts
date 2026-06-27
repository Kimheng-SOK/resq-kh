import { api } from '@/lib/api-client';
import type { EmergencyReport, PaginatedResponse } from './types';

export function getReports(): Promise<EmergencyReport[]> {
  return api.get<EmergencyReport[]>('/emergency-reports');
}

export function getReportsPaginated(
  page = 1,
  limit = 20,
  status?: string,
): Promise<PaginatedResponse<EmergencyReport>> {
  return api.get<PaginatedResponse<EmergencyReport>>(
    '/emergency-reports/paginated',
    {
      page: String(page),
      limit: String(limit),
      ...(status ? { status } : {}),
    },
  );
}

export function getReport(id: string): Promise<EmergencyReport> {
  return api.get<EmergencyReport>(`/emergency-reports/${id}`);
}

export function getReportsByUser(userId: string): Promise<EmergencyReport[]> {
  return api.get<EmergencyReport[]>(`/emergency-reports/user/${userId}`);
}

export function updateReportStatus(
  id: string,
  status: 'pending' | 'dispatched' | 'resolved',
): Promise<EmergencyReport> {
  return api.patch<EmergencyReport>(`/emergency-reports/${id}/status`, {
    status,
  });
}

export function deleteReport(
  id: string,
): Promise<{ deleted: boolean }> {
  return api.delete<{ deleted: boolean }>(`/emergency-reports/${id}`);
}
