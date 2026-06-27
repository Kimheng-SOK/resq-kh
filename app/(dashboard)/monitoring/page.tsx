import { getRecentActivity } from '@/lib/api/analytics';
import { MonitoringView } from './monitoring-view';

export const dynamic = 'force-dynamic';

export default async function MonitoringPage() {
  const activities = await getRecentActivity({ limit: 50 }).catch(() => []);

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Monitoring</h1>
        <p className="text-muted-foreground">
          Real-time activity across the platform
        </p>
      </div>
      <MonitoringView activities={activities} />
    </div>
  );
}
