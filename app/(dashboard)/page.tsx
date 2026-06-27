import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import {
  getDashboardOverview,
  getReportsTimeSeries,
  getReportsByStatus,
} from '@/lib/api/analytics';
import { getReports } from '@/lib/api/emergency-reports';
import { StatCard } from '@/components/charts/stat-card';
import {
  ReportsOverTimeChart,
  ReportsByStatusChart,
} from '@/components/charts/overview-charts';
import { Users2, FileWarning, Building2, Bell } from 'lucide-react';

export const dynamic = 'force-dynamic';

const REPORT_STATUS_STYLES: Record<string, string> = {
  pending: 'bg-amber-100 text-amber-800 border-amber-200',
  dispatched: 'bg-blue-100 text-blue-800 border-blue-200',
  resolved: 'bg-green-100 text-green-800 border-green-200',
};

function ReportStatusBadge({ status }: { status: string }) {
  return (
    <Badge variant="outline" className={REPORT_STATUS_STYLES[status] || ''}>
      {status}
    </Badge>
  );
}

function formatDateTime(dateStr: string): string {
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
}

function trendPct(thisWeek: number, lastWeek: number): string | undefined {
  if (lastWeek === 0 && thisWeek === 0) return undefined;
  if (lastWeek === 0) return `+${thisWeek} new`;
  const pct = (((thisWeek - lastWeek) / lastWeek) * 100).toFixed(1);
  const sign = Number(pct) >= 0 ? '+' : '';
  return `${sign}${pct}%`;
}

export default async function DashboardPage() {
  const [overview, reportsTimeSeries, reportsByStatus, recentReports] =
    await Promise.all([
      getDashboardOverview().catch(() => null),
      getReportsTimeSeries({ granularity: 'day' }).catch(() => []),
      getReportsByStatus().catch(() => []),
      getReports().catch(() => []),
    ]);

  const topReports = recentReports.slice(0, 5);

  return (
    <div className="space-y-6">
      {/* ── Stat Cards ── */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <StatCard
          title="Total Users"
          value={overview?.totalUsers ?? 0}
          icon={<Users2 className="h-4 w-4" />}
          subtitle="Registered users"
          trend={
            overview
              ? trendPct(
                  overview.recentTrends.newUsersThisWeek,
                  overview.recentTrends.newUsersLastWeek,
                )
              : undefined
          }
        />

        <StatCard
          title="Pending Reports"
          value={overview?.pendingReports ?? 0}
          icon={<FileWarning className="h-4 w-4" />}
          subtitle="Awaiting dispatch"
        />

        <StatCard
          title="Services"
          value={overview?.totalServices ?? 0}
          icon={<Building2 className="h-4 w-4" />}
          subtitle="Emergency services listed"
        />

        <StatCard
          title="Unread Notifications"
          value={overview?.unreadNotifications ?? 0}
          icon={<Bell className="h-4 w-4" />}
          subtitle={
            overview
              ? `${overview.totalNotifications} total notifications`
              : undefined
          }
        />
      </div>

      {/* ── Charts ── */}
      <div className="grid gap-4 md:grid-cols-2">
        <ReportsByStatusChart data={reportsByStatus} />
        <ReportsOverTimeChart data={reportsTimeSeries} />
      </div>

      {/* ── Recent Reports Table ── */}
      <Card>
        <CardHeader>
          <CardTitle>Recent Emergency Reports</CardTitle>
        </CardHeader>
        <CardContent>
          {topReports.length === 0 ? (
            <p className="text-sm text-muted-foreground">
              No reports submitted yet.
            </p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Reporter</TableHead>
                  <TableHead>Incident Type</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="hidden md:table-cell">
                    Description
                  </TableHead>
                  <TableHead className="hidden md:table-cell">Time</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {topReports.map((report) => (
                  <TableRow key={report.id}>
                    <TableCell className="font-medium">
                      <div>{report.reporter_name}</div>
                      <div className="text-xs text-muted-foreground">
                        {report.reporter_phone}
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline">
                        {report.incidentType?.label || 'N/A'}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <ReportStatusBadge status={report.status} />
                    </TableCell>
                    <TableCell className="hidden md:table-cell max-w-48 truncate">
                      {report.description || '—'}
                    </TableCell>
                    <TableCell className="hidden md:table-cell">
                      {formatDateTime(report.created_at)}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
