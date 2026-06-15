import { api } from '@/lib/api-client';
import type { AdminUser } from './types';

export function getAdmins(): Promise<AdminUser[]> {
  return api.get<AdminUser[]>('/admins');
}

export function getAdmin(id: string): Promise<AdminUser> {
  return api.get<AdminUser>(`/admins/${id}`);
}

export function createAdmin(data: {
  email: string;
  password: string;
  full_name?: string;
  role?: string;
}): Promise<AdminUser> {
  return api.post<AdminUser>('/admins', data);
}

export function updateAdmin(
  id: string,
  data: { email?: string; password?: string; full_name?: string; role?: string }
): Promise<AdminUser> {
  return api.patch<AdminUser>(`/admins/${id}`, data);
}

export function deleteAdmin(id: string): Promise<{ deleted: boolean }> {
  return api.delete<{ deleted: boolean }>(`/admins/${id}`);
}
