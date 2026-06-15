'use server';

import { serverApiRequest } from './server-request';
import type { User } from './types';

export async function updateUserAction(
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
  return serverApiRequest<User>(`/users/${id}`, {
    method: 'PATCH',
    body: data
  });
}

export async function deleteUserAction(
  id: string
): Promise<{ deleted: boolean }> {
  return serverApiRequest<{ deleted: boolean }>(`/users/${id}`, {
    method: 'DELETE'
  });
}
