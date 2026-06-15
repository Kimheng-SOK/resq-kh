import { notFound } from 'next/navigation';
import { getAdmins } from '@/lib/api/admins';
import { getSession } from '@/lib/session';
import { AdminsTable } from './admins-table';

export const dynamic = 'force-dynamic';

export default async function AdminsPage() {
  const session = await getSession();

  if (session?.role !== 'super_admin') {
    notFound();
  }

  const admins = await getAdmins().catch(() => []);

  return <AdminsTable admins={admins} />;
}
