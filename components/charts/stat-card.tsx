'use client';

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { TrendingDown, TrendingUp } from 'lucide-react';
import type { ReactNode } from 'react';

interface StatCardProps {
  title: string;
  value: number | string;
  icon: ReactNode;
  subtitle?: string;
  trend?: string;
}

export function StatCard({ title, value, icon, subtitle, trend }: StatCardProps) {
  const isPositive = trend ? !trend.startsWith('-') : false;

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-sm font-medium">{title}</CardTitle>
        <div className="h-4 w-4 text-muted-foreground">{icon}</div>
      </CardHeader>
      <CardContent>
        <div className="text-2xl font-bold">{value}</div>
        <p className="text-xs text-muted-foreground">
          {trend ? (
            <span
              className={`inline-flex items-center gap-0.5 ${
                isPositive ? 'text-green-600' : 'text-red-600'
              }`}
            >
              {isPositive ? (
                <TrendingUp className="h-3 w-3" />
              ) : (
                <TrendingDown className="h-3 w-3" />
              )}
              {trend}
            </span>
          ) : (
            subtitle || ''
          )}
        </p>
      </CardContent>
    </Card>
  );
}
