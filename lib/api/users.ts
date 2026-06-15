import { api } from '@/lib/api-client';
import type { User } from './types';

export function getUsers(): Promise<User[]> {
  return api.get<User[]>('/users');
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
