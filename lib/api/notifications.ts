import { api } from '@/lib/api-client';
import type { Notification } from './types';

export function getNotifications(): Promise<Notification[]> {
  return api.get<Notification[]>('/notifications');
}
