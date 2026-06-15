import { api } from '@/lib/api-client';
import type { UserLocation } from './types';

export function getUserLocations(userId: string): Promise<UserLocation[]> {
  return api.get<UserLocation[]>('/user-locations', { user_id: userId });
}
