'use client';

import Link from 'next/link';
import { Badge } from '@/components/ui/badge';
import { Siren, FileText, UserPlus, Bell } from 'lucide-react';
import type { ActivityItem as ActivityItemType } from '@/lib/api/types';

const TYPE_ICONS: Record<string, React.ElementType> = {
  alert: Siren,
  report: FileText,
  user: UserPlus,
  notification: Bell,
};

const TYPE_LINKS: Record<string, (id: string) => string> = {
  alert: (id: string) => `/emergency-alerts/${id}`,
  report: (id: string) => `/emergency-alerts`, // reports detail page may not exist yet
  user: (id: string) => `/users/${id}`,
  notification: (id: string) => `/emergency-alerts`,
};

function relativeTime(dateStr: string): string {
  const seconds = Math.floor((Date.now() - new Date(dateStr).getTime()) / 1000);

  if (seconds < 60) return 'just now';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  if (days < 7) return `${days}d ago`;
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
  });
}

export function ActivityItem({ activity }: { activity: ActivityItemType }) {
  const Icon = TYPE_ICONS[activity.type] || Bell;
  const linkHref =
    TYPE_LINKS[activity.type]?.(activity.relatedId || '') || '#';

  return (
    <Link href={linkHref}>
      <div className="flex items-start gap-3 rounded-lg p-3 transition-colors hover:bg-muted/50">
        <div className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-muted">
          <Icon className="h-4 w-4 text-muted-foreground" />
        </div>
        <div className="flex-1 min-w-0">
          <p className="text-sm truncate">{activity.description}</p>
          <p className="text-xs text-muted-foreground">
            {relativeTime(activity.timestamp)}
          </p>
        </div>
        <div className="shrink-0">
          <Badge
            variant="outline"
            className={
              activity.status === 'active' || activity.status === 'unread'
                ? 'bg-red-100 text-red-800 border-red-200'
                : activity.status === 'resolved' || activity.status === 'read'
                  ? 'bg-green-100 text-green-800 border-green-200'
                  : 'bg-gray-100 text-gray-800 border-gray-200'
            }
          >
            {activity.status}
          </Badge>
        </div>
      </div>
    </Link>
  );
}
