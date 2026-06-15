import { api } from '@/lib/api-client';
import type { EmergencyAlert } from './types';

export function getAlerts(params?: {
  userId?: string;
}): Promise<EmergencyAlert[]> {
  return api.get<EmergencyAlert[]>('/emergency-alerts', params as Record<string, string>);
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
