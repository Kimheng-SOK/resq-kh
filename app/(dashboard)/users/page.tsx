import { getSession } from '@/lib/session';
import { getUsers } from '@/lib/api/users';
import { UsersTable } from './users-table';

export const dynamic = 'force-dynamic';

export default async function UsersPage(props: {
  searchParams: Promise<{ q: string }>;
}) {
  const searchParams = await props.searchParams;
  const search = searchParams.q ?? '';

  const session = await getSession();
  const canModify =
    session?.role === 'super_admin' || session?.role === 'moderator';

  const users = await getUsers().catch(() => []);

  const filtered = search
    ? users.filter(
        (u) =>
          (u.full_name || '').toLowerCase().includes(search.toLowerCase()) ||
          (u.email || '').toLowerCase().includes(search.toLowerCase()) ||
          (u.phone_number || '').toLowerCase().includes(search.toLowerCase())
      )
    : users;

  return (
    <UsersTable users={filtered} totalCount={users.length} canModify={canModify} />
  );
}
