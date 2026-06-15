import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { getUsers } from '@/lib/api/users';
import { getAlerts } from '@/lib/api/emergency-alerts';
import { getServices } from '@/lib/api/services';
import { getNotifications } from '@/lib/api/notifications';
import { Siren, Users2, Building2, Bell } from 'lucide-react';

export const dynamic = 'force-dynamic';

function StatusBadge({ status }: { status: string }) {
  const variants: Record<string, string> = {
    active: 'bg-red-100 text-red-800 border-red-200',
    resolved: 'bg-green-100 text-green-800 border-green-200',
    cancelled: 'bg-gray-100 text-gray-800 border-gray-200'
  };
  return (
    <Badge variant="outline" className={variants[status] || ''}>
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
    minute: '2-digit'
  });
}

export default async function DashboardPage() {
  const [users, alerts, services, notifications] = await Promise.all([
    getUsers().catch(() => []),
    getAlerts().catch(() => []),
    getServices().catch(() => []),
    getNotifications().catch(() => [])
  ]);

  const activeAlerts = alerts.filter((a) => a.status === 'active').length;
  const unreadNotifications = notifications.filter((n) => !n.is_read).length;
  const recentAlerts = alerts.slice(0, 5);

  return (
    <div className="space-y-6">
      {/* Stats Cards */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Users</CardTitle>
            <Users2 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{users.length}</div>
            <p className="text-xs text-muted-foreground">
              Registered users on the platform
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Active Alerts</CardTitle>
            <Siren className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{activeAlerts}</div>
            <p className="text-xs text-muted-foreground">
              {alerts.length} total, {activeAlerts} currently active
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Services</CardTitle>
            <Building2 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{services.length}</div>
            <p className="text-xs text-muted-foreground">
              Emergency services listed
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">
              Unread Notifications
            </CardTitle>
            <Bell className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{unreadNotifications}</div>
            <p className="text-xs text-muted-foreground">
              {notifications.length} total notifications
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Recent Alerts */}
      <Card>
        <CardHeader>
          <CardTitle>Recent Emergency Alerts</CardTitle>
        </CardHeader>
        <CardContent>
          {recentAlerts.length === 0 ? (
            <p className="text-sm text-muted-foreground">No alerts found.</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>User</TableHead>
                  <TableHead>Type</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="hidden md:table-cell">Location</TableHead>
                  <TableHead className="hidden md:table-cell">Time</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {recentAlerts.map((alert) => (
                  <TableRow key={alert.id}>
                    <TableCell className="font-medium">
                      {alert.user?.full_name || alert.user?.phone_number || 'Unknown'}
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline">
                        {alert.emergency_type?.label || 'N/A'}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <StatusBadge status={alert.status} />
                    </TableCell>
                    <TableCell className="hidden md:table-cell">
                      {alert.location
                        ? `${Number(alert.location.latitude).toFixed(4)}, ${Number(alert.location.longitude).toFixed(4)}`
                        : '—'}
                    </TableCell>
                    <TableCell className="hidden md:table-cell">
                      {formatDateTime(alert.created_at)}
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
