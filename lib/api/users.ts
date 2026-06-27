import { api } from '@/lib/api-client';
import type { User, PaginatedResponse } from './types';

export function getUsers(): Promise<User[]> {
  return api.get<User[]>('/users');
}

export function getUsersPaginated(
  page = 1,
  limit = 20,
): Promise<PaginatedResponse<User>> {
  return api.get<PaginatedResponse<User>>('/users/paginated', {
    page: String(page),
    limit: String(limit),
  });
}

export function getUser(id: string): Promise<User> {
  return api.get<User>(`/users/${id}`);
}

export function updateUser(
  id: string,
  data: Partial<{
    full_name: string;
    phone_number: string;
    blood_group: string;
    allergies: string;
    medical_conditions: string;
    preferred_language: string;
  }>
): Promise<User> {
  return api.patch<User>(`/users/${id}`, data);
}

export function deleteUser(id: string): Promise<{ deleted: boolean }> {
  return api.delete<{ deleted: boolean }>(`/users/${id}`);
}
