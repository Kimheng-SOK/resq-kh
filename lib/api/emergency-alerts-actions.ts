'use server';

import { serverApiRequest } from './server-request';
import type { EmergencyAlert } from './types';

export async function updateAlertStatusAction(
  id: string,
  status: 'resolved' | 'cancelled'
): Promise<EmergencyAlert> {
  return serverApiRequest<EmergencyAlert>(`/emergency-alerts/${id}`, {
    method: 'PATCH',
    body: { status }
  });
}
