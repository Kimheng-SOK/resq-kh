const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';

interface RequestOptions {
  method?: string;
  body?: unknown;
  params?: Record<string, string | undefined>;
}

async function getToken(): Promise<string | undefined> {
  if (typeof window === 'undefined') {
    // Server-side: read from httpOnly cookie
    const { cookies } = await import('next/headers');
    const cookieStore = await cookies();
    return cookieStore.get('resq_token')?.value;
  }
  // Client-side: read from document.cookie (for mutations in client components)
  const match = document.cookie.match(/(?:^|;\s*)resq_token=([^;]*)/);
  return match ? match[1] : undefined;
}

export async function apiRequest<T>(
  path: string,
  options: RequestOptions = {}
): Promise<T> {
  const token = await getToken();

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

  // Backend wraps all responses as { statusCode, message, data }
  const json = await response.json();
  return (json as { data: T }).data;
}

export const api = {
  get: <T>(path: string, params?: Record<string, string | undefined>) =>
    apiRequest<T>(path, { params }),

  post: <T>(path: string, body?: unknown) =>
    apiRequest<T>(path, { method: 'POST', body }),

  patch: <T>(path: string, body?: unknown) =>
    apiRequest<T>(path, { method: 'PATCH', body }),

  delete: <T>(path: string) => apiRequest<T>(path, { method: 'DELETE' })
};
