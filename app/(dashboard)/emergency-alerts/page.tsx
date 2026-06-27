import { getAlertsPaginated } from '@/lib/api/emergency-alerts';
import { AlertsTable } from './alerts-table';

export const dynamic = 'force-dynamic';

const PAGE_SIZE = 50;

export default async function EmergencyAlertsPage(props: {
  searchParams: Promise<{ q: string; status: string; page: string }>;
}) {
  const searchParams = await props.searchParams;
  const search = searchParams.q ?? '';
  const statusFilter =
    searchParams.status && searchParams.status !== 'all'
      ? searchParams.status
      : undefined;
  const page = parseInt(searchParams.page ?? '1', 10) || 1;

  const result = await getAlertsPaginated(page, PAGE_SIZE, statusFilter).catch(
    () => null,
  );

  // Client-side text search (name, phone, type label)
  let filtered = result?.data ?? [];
  if (search) {
    const q = search.toLowerCase();
    filtered = filtered.filter(
      (a) =>
        (a.user?.full_name || '').toLowerCase().includes(q) ||
        (a.user?.phone_number || '').toLowerCase().includes(q) ||
        (a.emergency_type?.label || '').toLowerCase().includes(q),
    );
  }

  return (
    <AlertsTable
      alerts={filtered}
      totalCount={result?.total ?? 0}
      currentStatus={searchParams.status ?? 'all'}
      currentPage={result?.page ?? 1}
      totalPages={result?.totalPages ?? 1}
    />
  );
}
