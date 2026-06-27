'use server';

import { serverApiRequest } from './server-request';
import type { EmergencyReport } from './types';

export async function updateReportStatusAction(
  id: string,
  status: 'pending' | 'dispatched' | 'resolved',
): Promise<EmergencyReport> {
  return serverApiRequest<EmergencyReport>(`/emergency-reports/${id}/status`, {
    method: 'PATCH',
    body: { status },
  });
}

export async function deleteReportAction(
  id: string,
): Promise<{ deleted: boolean }> {
  return serverApiRequest<{ deleted: boolean }>(`/emergency-reports/${id}`, {
    method: 'DELETE',
  });
}
