import { api } from '@/lib/api-client';
import type { EmergencyAlert, PaginatedResponse } from './types';

export function getAlerts(params?: {
  userId?: string;
}): Promise<EmergencyAlert[]> {
  return api.get<EmergencyAlert[]>('/emergency-alerts', params as Record<string, string>);
}

export function getAlertsPaginated(
  page = 1,
  limit = 20,
  status?: string,
): Promise<PaginatedResponse<EmergencyAlert>> {
  return api.get<PaginatedResponse<EmergencyAlert>>(
    '/emergency-alerts/paginated',
    {
      page: String(page),
      limit: String(limit),
      ...(status ? { status } : {}),
    },
  );
}

export function getAlert(id: string): Promise<EmergencyAlert> {
  return api.get<EmergencyAlert>(`/emergency-alerts/${id}`);
}

export function updateAlertStatus(
  id: string,
  status: 'resolved' | 'cancelled'
): Promise<EmergencyAlert> {
  return api.patch<EmergencyAlert>(`/emergency-alerts/${id}`, { status });
}
