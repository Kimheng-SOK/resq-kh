import 'server-only';

import { cookies } from 'next/headers';
import type { AuthSession } from './auth-types';

export async function getSession(): Promise<AuthSession | null> {
  const cookieStore = await cookies();
  const token = cookieStore.get('resq_token')?.value;
  if (!token) return null;

  try {
    // Decode JWT payload without verification (backend handles that)
    const payload = JSON.parse(
      Buffer.from(token.split('.')[1], 'base64').toString()
    ) as AuthSession & { iat?: number; exp?: number };
    return {
      sub: payload.sub,
      email: payload.email,
      role: payload.role,
      full_name: payload.full_name
    };
  } catch {
    return null;
  }
}
