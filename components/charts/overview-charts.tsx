'use client';

import {
  PieChart,
  Pie,
  Cell,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  BarChart,
  Bar,
  ResponsiveContainer,
} from 'recharts';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import type {
  AlertTypeBreakdown,
  StatusBreakdown,
  TimeSeriesPoint,
} from '@/lib/api/types';

// ── Color palettes ──
const STATUS_COLORS: Record<string, string> = {
  active: '#ef4444',    // red-500
  resolved: '#22c55e',  // green-500
  cancelled: '#6b7280', // gray-500
  pending: '#f59e0b',   // amber-500
  dispatched: '#3b82f6', // blue-500
};

const PIE_COLORS = [
  '#ef4444', '#22c55e', '#3b82f6', '#f59e0b', '#a855f7',
  '#ec4899', '#14b8a6', '#f97316', '#6366f1', '#84cc16',
];

// ── Helpers ──

function formatPeriod(period: string): string {
  const d = new Date(period);
  if (isNaN(d.getTime())) {
    // May already be truncated text
    return period.length > 10 ? period.slice(0, 10) : period;
  }
  return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
}

// ── Chart components ──

interface ChartCardProps {
  title: string;
  children: React.ReactNode;
}

function ChartCard({ title, children }: ChartCardProps) {
  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-sm font-medium">{title}</CardTitle>
      </CardHeader>
      <CardContent className="h-72">{children}</CardContent>
    </Card>
  );
}

// ── Alerts by Emergency Type (Donut) ──

export function AlertsByTypeChart({ data }: { data: AlertTypeBreakdown[] }) {
  if (!data || data.length === 0) {
    return (
      <ChartCard title="Alerts by Emergency Type">
        <p className="text-sm text-muted-foreground text-center pt-16">
          No data available
        </p>
      </ChartCard>
    );
  }

  const chartData = data.map((d) => ({
    name: d.label,
    value: parseInt(d.count, 10),
    color: d.color || undefined,
  }));

  return (
    <ChartCard title="Alerts by Emergency Type">
      <ResponsiveContainer width="100%" height="100%">
        <PieChart>
          <Pie
            data={chartData}
            cx="50%"
            cy="50%"
            innerRadius={60}
            outerRadius={90}
            paddingAngle={2}
            dataKey="value"
          >
            {chartData.map((entry, index) => (
              <Cell
                key={entry.name}
                fill={entry.color || PIE_COLORS[index % PIE_COLORS.length]}
              />
            ))}
          </Pie>
          <Tooltip formatter={(value) => [`${value} alerts`, 'Count']} />
          <Legend />
        </PieChart>
      </ResponsiveContainer>
    </ChartCard>
  );
}

// ── Alerts Over Time (Line) ──

export function AlertsOverTimeChart({ data }: { data: TimeSeriesPoint[] }) {
  if (!data || data.length === 0) {
    return (
      <ChartCard title="Alerts Over Time">
        <p className="text-sm text-muted-foreground text-center pt-16">
          No data available
        </p>
      </ChartCard>
    );
  }

  const chartData = data.map((d) => ({
    period: formatPeriod(d.period),
    alerts: parseInt(d.count, 10),
  }));

  return (
    <ChartCard title="Alerts Over Time">
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={chartData}>
          <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
          <XAxis
            dataKey="period"
            className="text-xs"
            tick={{ fontSize: 12 }}
          />
          <YAxis className="text-xs" tick={{ fontSize: 12 }} />
          <Tooltip />
          <Line
            type="monotone"
            dataKey="alerts"
            stroke="#ef4444"
            strokeWidth={2}
            dot={false}
            activeDot={{ r: 4 }}
          />
        </LineChart>
      </ResponsiveContainer>
    </ChartCard>
  );
}

// ── Reports by Status (Bar) ──

export function ReportsByStatusChart({ data }: { data: StatusBreakdown[] }) {
  if (!data || data.length === 0) {
    return (
      <ChartCard title="Reports by Status">
        <p className="text-sm text-muted-foreground text-center pt-16">
          No data available
        </p>
      </ChartCard>
    );
  }

  const chartData = data.map((d) => ({
    status: d.status.charAt(0).toUpperCase() + d.status.slice(1),
    count: parseInt(d.count, 10),
    fill: STATUS_COLORS[d.status] || '#6b7280',
  }));

  return (
    <ChartCard title="Reports by Status">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={chartData}>
          <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
          <XAxis
            dataKey="status"
            className="text-xs"
            tick={{ fontSize: 12 }}
          />
          <YAxis className="text-xs" tick={{ fontSize: 12 }} />
          <Tooltip formatter={(value) => [`${value} reports`, 'Count']} />
          <Bar dataKey="count" radius={[4, 4, 0, 0]}>
            {chartData.map((entry) => (
              <Cell key={entry.status} fill={entry.fill} />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </ChartCard>
  );
}

// ── Reports Over Time (Line) ──

export function ReportsOverTimeChart({ data }: { data: TimeSeriesPoint[] }) {
  if (!data || data.length === 0) {
    return (
      <ChartCard title="Reports Over Time">
        <p className="text-sm text-muted-foreground text-center pt-16">
          No data available
        </p>
      </ChartCard>
    );
  }

  const chartData = data.map((d) => ({
    period: formatPeriod(d.period),
    reports: parseInt(d.count, 10),
  }));

  return (
    <ChartCard title="Reports Over Time">
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={chartData}>
          <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
          <XAxis
            dataKey="period"
            className="text-xs"
            tick={{ fontSize: 12 }}
          />
          <YAxis className="text-xs" tick={{ fontSize: 12 }} />
          <Tooltip />
          <Line
            type="monotone"
            dataKey="reports"
            stroke="#3b82f6"
            strokeWidth={2}
            dot={false}
            activeDot={{ r: 4 }}
          />
        </LineChart>
      </ResponsiveContainer>
    </ChartCard>
  );
}
