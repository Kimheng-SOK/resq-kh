import { getAlerts } from '@/lib/api/emergency-alerts';
import { AlertsTable } from './alerts-table';

export const dynamic = 'force-dynamic';

export default async function EmergencyAlertsPage(
  props: {
    searchParams: Promise<{ q: string; status: string }>;
  }
) {
  const searchParams = await props.searchParams;
  const search = searchParams.q ?? '';
  const statusFilter = searchParams.status ?? 'all';

  const alerts = await getAlerts().catch(() => []);

  // Client-side filtering
  let filtered = alerts;
  if (statusFilter !== 'all') {
    filtered = alerts.filter((a) => a.status === statusFilter);
  }
  if (search) {
    const q = search.toLowerCase();
    filtered = filtered.filter(
      (a) =>
        (a.user?.full_name || '').toLowerCase().includes(q) ||
        (a.user?.phone_number || '').toLowerCase().includes(q) ||
        (a.emergency_type?.label || '').toLowerCase().includes(q)
    );
  }

  return (
    <AlertsTable
      alerts={filtered}
      totalCount={alerts.length}
      currentStatus={statusFilter}
    />
  );
}
