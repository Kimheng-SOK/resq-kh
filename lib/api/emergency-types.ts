import { api } from '@/lib/api-client';
import type { EmergencyType } from './types';

export function getEmergencyTypes(): Promise<EmergencyType[]> {
  return api.get<EmergencyType[]>('/emergency-types');
}
