import { getReportsPaginated } from '@/lib/api/emergency-reports';
import { ReportsTable } from './reports-table';

export const dynamic = 'force-dynamic';

const PAGE_SIZE = 50;

export default async function EmergencyReportsPage(props: {
  searchParams: Promise<{ q: string; status: string; page: string }>;
}) {
  const searchParams = await props.searchParams;
  const search = searchParams.q ?? '';
  const statusFilter =
    searchParams.status && searchParams.status !== 'all'
      ? searchParams.status
      : undefined;
  const page = parseInt(searchParams.page ?? '1', 10) || 1;

  const result = await getReportsPaginated(page, PAGE_SIZE, statusFilter).catch(
    () => null,
  );

  // Client-side text search (reporter name, phone, incident type, description)
  let filtered = result?.data ?? [];
  if (search) {
    const q = search.toLowerCase();
    filtered = filtered.filter(
      (r) =>
        (r.reporter_name || '').toLowerCase().includes(q) ||
        (r.reporter_phone || '').toLowerCase().includes(q) ||
        (r.incidentType?.label || '').toLowerCase().includes(q) ||
        (r.description || '').toLowerCase().includes(q),
    );
  }

  return (
    <ReportsTable
      reports={filtered}
      totalCount={result?.total ?? 0}
      currentStatus={searchParams.status ?? 'all'}
      currentPage={result?.page ?? 1}
      totalPages={result?.totalPages ?? 1}
    />
  );
}
