'use client';

import { Badge } from '@/components/ui/badge';
import { Bell, UserPlus, Siren } from 'lucide-react';
import type { Notification, User } from '@/lib/api/types';

const TYPE_ICONS: Record<string, React.ElementType> = {
  report_alert: Siren,
  admin_broadcast: Bell,
  admin_direct: UserPlus,
};

const TYPE_LABELS: Record<string, string> = {
  report_alert: 'Report Alert',
  admin_broadcast: 'Broadcast',
  admin_direct: 'Direct',
};

function formatDate(dateStr: string): string {
  if (!dateStr) return '';
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
}

export function NotificationsList({
  notifications,
  users,
}: {
  notifications: Notification[];
  users: User[];
}) {
  const userMap = new Map(users.map((u) => [u.id, u]));

  if (notifications.length === 0) {
    return (
      <p className="text-sm text-muted-foreground py-8 text-center">
        No notifications sent yet.
      </p>
    );
  }

  return (
    <div className="divide-y divide-border max-h-96 overflow-y-auto">
      {notifications.slice(0, 30).map((n) => {
        const Icon = TYPE_ICONS[n.type || ''] || Bell;
        const userName =
          n.user_id && userMap.get(n.user_id)?.full_name;

        return (
          <div key={n.id} className="flex items-start gap-3 py-3">
            <div className="mt-0.5 flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-muted">
              <Icon className="h-3.5 w-3.5 text-muted-foreground" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2">
                <p className="text-sm font-medium truncate">{n.title}</p>
                <Badge variant="outline" className="text-xs shrink-0">
                  {TYPE_LABELS[n.type || ''] || n.type}
                </Badge>
              </div>
              <p className="text-xs text-muted-foreground line-clamp-2">
                {n.body}
              </p>
              <div className="flex items-center gap-2 mt-1">
                {userName && (
                  <span className="text-xs text-muted-foreground">
                    To: {userName}
                  </span>
                )}
                <span className="text-xs text-muted-foreground">
                  {formatDate(n.created_at)}
                </span>
                {n.is_read ? (
                  <Badge
                    variant="outline"
                    className="text-xs bg-green-50 text-green-700"
                  >
                    Read
                  </Badge>
                ) : (
                  <Badge
                    variant="outline"
                    className="text-xs bg-amber-50 text-amber-700"
                  >
                    Unread
                  </Badge>
                )}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}
