import { api } from '@/lib/api-client';
import type { Service } from './types';

export function getServices(): Promise<Service[]> {
  return api.get<Service[]>('/services');
}

export function getService(id: string): Promise<Service> {
  return api.get<Service>(`/services/${id}`);
}

export function createService(data: {
  name: string;
  category: string;
  phone_number: string;
  address?: string;
  latitude?: number;
  longitude?: number;
  description?: string;
}): Promise<Service> {
  return api.post<Service>('/services', data);
}

export function updateService(
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
  return api.patch<Service>(`/services/${id}`, data);
}

export function deleteService(id: string): Promise<{ deleted: boolean }> {
  return api.delete<{ deleted: boolean }>(`/services/${id}`);
}
