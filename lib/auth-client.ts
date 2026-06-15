'use server';

import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';
import { login as apiLogin } from '@/lib/api/auth';

export async function loginAction(
  _prevState: { error: string } | null,
  formData: FormData
): Promise<{ error: string }> {
  const email = formData.get('email') as string;
  const password = formData.get('password') as string;

  if (!email || !password) {
    return { error: 'Email and password are required.' };
  }

  try {
    const result = await apiLogin(email, password);

    const cookieStore = await cookies();
    cookieStore.set('resq_token', result.access_token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60, // 7 days
      path: '/'
    });

    // Also store basic session info for quick access
    cookieStore.set('resq_session', JSON.stringify({
      sub: result.admin.id,
      email: result.admin.email,
      role: result.admin.role,
      full_name: result.admin.full_name
    }), {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60,
      path: '/'
    });
  } catch (err) {
    return {
      error:
        err instanceof Error ? err.message : 'Login failed. Please try again.'
    };
  }

  redirect('/');
}

export async function logoutAction() {
  'use server';
  const cookieStore = await cookies();
  cookieStore.delete('resq_token');
  cookieStore.delete('resq_session');
  redirect('/login');
}
