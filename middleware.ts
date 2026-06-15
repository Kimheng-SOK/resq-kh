import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const publicPaths = ['/login'];

export function middleware(request: NextRequest) {
  const token = request.cookies.get('resq_token')?.value;
  const { pathname } = request.nextUrl;

  // Allow public paths without auth
  if (publicPaths.some((p) => pathname.startsWith(p))) {
    // If already logged in and on login page, redirect to dashboard
    if (token && pathname === '/login') {
      return NextResponse.redirect(new URL('/', request.url));
    }
    return NextResponse.next();
  }

  // Protect dashboard routes
  if (!token) {
    const loginUrl = new URL('/login', request.url);
    loginUrl.searchParams.set('callbackUrl', pathname);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/((?!api|_next/static|_next/image|favicon.ico).*)']
};
