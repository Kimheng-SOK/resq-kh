import { api } from '@/lib/api-client';
import type { Notification } from './types';

export function getNotifications(params?: {
  userId?: string;
  type?: string;
}): Promise<Notification[]> {
  return api.get<Notification[]>(
    '/notifications',
    params as Record<string, string>,
  );
}

export function markNotificationRead(id: string): Promise<Notification> {
  return api.patch<Notification>(`/notifications/${id}/read`);
}

export function sendNotification(body: {
  userIds: string[];
  title: string;
  body: string;
  broadcast?: boolean;
}): Promise<Notification[]> {
  return api.post<Notification[]>('/notifications/send', body);
}
