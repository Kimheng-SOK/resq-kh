export type AdminRole = 'super_admin' | 'moderator' | 'viewer';

export interface AuthSession {
  sub: string;
  email: string;
  role: AdminRole;
  full_name: string | null;
}
