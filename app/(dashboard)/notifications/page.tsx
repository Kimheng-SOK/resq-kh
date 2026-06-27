import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { getUsers } from '@/lib/api/users';
import { getNotifications } from '@/lib/api/notifications';
import { SendNotificationForm } from './send-form';
import { NotificationsList } from './notifications-list';

export const dynamic = 'force-dynamic';

export default async function NotificationsPage() {
  const [users, notifications] = await Promise.all([
    getUsers().catch(() => []),
    getNotifications().catch(() => []),
  ]);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Notifications</h1>
        <p className="text-muted-foreground">
          Send emergency notifications to users and view notification history.
        </p>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <SendNotificationForm users={users} />
        <Card>
          <CardHeader>
            <CardTitle>Notification History</CardTitle>
          </CardHeader>
          <CardContent>
            <NotificationsList notifications={notifications} users={users} />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
