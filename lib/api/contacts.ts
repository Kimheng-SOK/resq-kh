import { api } from '@/lib/api-client';
import type { Contact } from './types';

export function getContacts(userId: string): Promise<Contact[]> {
  return api.get<Contact[]>('/contacts', { user_id: userId });
}
