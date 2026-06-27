'use server';

import { serverApiRequest } from './server-request';
import type { Notification } from './types';

export async function sendNotificationAction(body: {
  userIds: string[];
  title: string;
  body: string;
  broadcast?: boolean;
}): Promise<Notification[]> {
  return serverApiRequest<Notification[]>('/notifications/send', {
    method: 'POST',
    body,
  });
}
