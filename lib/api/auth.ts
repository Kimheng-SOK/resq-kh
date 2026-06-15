import { api } from '@/lib/api-client';
import type { AuthSession } from '@/lib/auth-types';

interface LoginResponse {
  access_token: string;
  admin: {
    id: string;
    email: string;
    role: AuthSession['role'];
    full_name: string | null;
  };
}

export async function login(email: string, password: string): Promise<LoginResponse> {
  return api.post<LoginResponse>('/auth/login', { email, password });
}

export function getProfile(): Promise<LoginResponse['admin']> {
  return api.get<LoginResponse['admin']>('/auth/profile');
}
