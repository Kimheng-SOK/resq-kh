'use server';

import { serverApiRequest } from './server-request';
import type { Service } from './types';

export async function createServiceAction(data: {
  name: string;
  category: string;
  phone_number: string;
  address?: string;
  latitude?: number;
  longitude?: number;
  description?: string;
}): Promise<Service> {
  return serverApiRequest<Service>('/services', { method: 'POST', body: data });
}

export async function updateServiceAction(
  id: string,
  data: Partial<{
    name: string;
    category: string;
    phone_number: string;
    address: string;
    latitude: number;
    longitude: number;
    description: string;
    is_active: boolean;
  }>
): Promise<Service> {
  return serverApiRequest<Service>(`/services/${id}`, {
    method: 'PATCH',
    body: data
  });
}

export async function deleteServiceAction(
  id: string
): Promise<{ deleted: boolean }> {
  return serverApiRequest<{ deleted: boolean }>(`/services/${id}`, {
    method: 'DELETE'
  });
}
