'use client';

import { useState, useMemo } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ActivityItem } from './activity-item';
import type { ActivityItem as ActivityItemType } from '@/lib/api/types';

const TYPE_TABS = [
  { value: 'all', label: 'All' },
  { value: 'alert', label: 'Alerts' },
  { value: 'report', label: 'Reports' },
  { value: 'user', label: 'Users' },
  { value: 'notification', label: 'Notifications' },
];

const TIME_TABS = [
  { value: 'all', label: 'All Time' },
  { value: 'today', label: 'Today' },
  { value: 'week', label: 'This Week' },
  { value: 'month', label: 'This Month' },
];

export function MonitoringView({
  activities,
}: {
  activities: ActivityItemType[];
}) {
  const [typeFilter, setTypeFilter] = useState('all');
  const [timeFilter, setTimeFilter] = useState('all');

  const filtered = useMemo(() => {
    const now = Date.now();
    const MS_HOUR = 3600_000;
    const MS_DAY = 86_400_000;
    const MS_WEEK = 604_800_000;
    const MS_MONTH = 2_592_000_000;

    return activities.filter((a) => {
      // Type filter
      if (typeFilter !== 'all' && a.type !== typeFilter) return false;

      // Time filter
      if (timeFilter === 'all') return true;
      const age = now - new Date(a.timestamp).getTime();
      switch (timeFilter) {
        case 'today':
          return age < MS_DAY;
        case 'week':
          return age < MS_WEEK;
        case 'month':
          return age < MS_MONTH;
        default:
          return true;
      }
    });
  }, [activities, typeFilter, timeFilter]);

  return (
    <Card>
      <CardHeader className="pb-3">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <CardTitle className="text-sm font-medium">Activity Feed</CardTitle>
          <div className="flex flex-col gap-2 sm:flex-row">
            <Tabs value={typeFilter} onValueChange={setTypeFilter}>
              <TabsList className="h-8">
                {TYPE_TABS.map((t) => (
                  <TabsTrigger key={t.value} value={t.value} className="text-xs px-2">
                    {t.label}
                  </TabsTrigger>
                ))}
              </TabsList>
            </Tabs>
            <Tabs value={timeFilter} onValueChange={setTimeFilter}>
              <TabsList className="h-8">
                {TIME_TABS.map((t) => (
                  <TabsTrigger key={t.value} value={t.value} className="text-xs px-2">
                    {t.label}
                  </TabsTrigger>
                ))}
              </TabsList>
            </Tabs>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        {filtered.length === 0 ? (
          <p className="text-sm text-muted-foreground py-8 text-center">
            No activity found for the selected filters.
          </p>
        ) : (
          <div className="divide-y divide-border">
            {filtered.map((activity) => (
              <ActivityItem key={activity.id} activity={activity} />
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
