'use server';

import { serverApiRequest } from './server-request';
import type { AdminUser } from './types';

export async function createAdminAction(data: {
  email: string;
  password: string;
  full_name?: string;
  role?: string;
}): Promise<AdminUser> {
  return serverApiRequest<AdminUser>('/admins', { method: 'POST', body: data });
}

export async function updateAdminAction(
  id: string,
  data: {
    email?: string;
    password?: string;
    full_name?: string;
    role?: string;
  }
): Promise<AdminUser> {
  return serverApiRequest<AdminUser>(`/admins/${id}`, {
    method: 'PATCH',
    body: data
  });
}

export async function deleteAdminAction(
  id: string
): Promise<{ deleted: boolean }> {
  return serverApiRequest<{ deleted: boolean }>(`/admins/${id}`, {
    method: 'DELETE'
  });
}
