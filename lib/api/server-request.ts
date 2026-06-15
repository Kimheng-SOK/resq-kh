'use server';

import { cookies } from 'next/headers';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';

interface RequestOptions {
  method?: string;
  body?: unknown;
  params?: Record<string, string | undefined>;
}

/**
 * Server-side API request helper.
 * Reads the httpOnly resq_token cookie via next/headers — works where
 * the client-side apiRequest (which uses document.cookie) cannot.
 */
export async function serverApiRequest<T>(
  path: string,
  options: RequestOptions = {}
): Promise<T> {
  const cookieStore = await cookies();
  const token = cookieStore.get('resq_token')?.value;

  const url = new URL(`${API_URL}${path}`);
  if (options.params) {
    Object.entries(options.params).forEach(([k, v]) => {
      if (v !== undefined) url.searchParams.set(k, v);
    });
  }

  const headers: HeadersInit = {
    'Content-Type': 'application/json'
  };
  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const response = await fetch(url.toString(), {
    method: options.method || 'GET',
    headers,
    body: options.body ? JSON.stringify(options.body) : undefined,
    cache: 'no-store'
  });

  if (response.status === 401) {
    throw new Error('Unauthorized');
  }

  if (!response.ok) {
    const errorBody = await response
      .json()
      .catch(() => ({ message: response.statusText }));
    throw new Error(
      (errorBody as { message?: string }).message ||
        `API Error: ${response.status}`
    );
  }

  const json = await response.json();
  return (json as { data: T }).data;
}
