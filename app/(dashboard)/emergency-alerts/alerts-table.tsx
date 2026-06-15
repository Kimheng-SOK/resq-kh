'use client';

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle
} from '@/components/ui/card';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useRouter } from 'next/navigation';
import type { EmergencyAlert } from '@/lib/api/types';
import { useSort } from '@/lib/hooks/use-sort';
import { SortableHeader } from '@/components/ui/sortable-header';
import { AlertRow } from './alert-row';

export function AlertsTable({
  alerts,
  totalCount,
  currentStatus
}: {
  alerts: EmergencyAlert[];
  totalCount: number;
  currentStatus: string;
}) {
  const router = useRouter();
  const { sortColumn, sortDirection, toggleSort, sortedData } =
    useSort('created_at');

  function onTabChange(value: string) {
    router.push(`/emergency-alerts?status=${value}`);
  }

  return (
    <Tabs defaultValue={currentStatus} onValueChange={onTabChange}>
      <div className="flex items-center">
        <TabsList>
          <TabsTrigger value="all">All ({totalCount})</TabsTrigger>
          <TabsTrigger value="active">Active</TabsTrigger>
          <TabsTrigger value="resolved">Resolved</TabsTrigger>
          <TabsTrigger value="cancelled">Cancelled</TabsTrigger>
        </TabsList>
      </div>
      <TabsContent value={currentStatus}>
        <Card>
          <CardHeader>
            <CardTitle>Emergency Alerts</CardTitle>
            <CardDescription>
              View and manage all emergency alerts from users.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <SortableHeader
                    column="user"
                    label="User"
                    sortColumn={sortColumn}
                    sortDirection={sortDirection}
                    onSort={toggleSort}
                  />
                  <SortableHeader
                    column="emergency_type"
                    label="Type"
                    sortColumn={sortColumn}
                    sortDirection={sortDirection}
                    onSort={toggleSort}
                  />
                  <SortableHeader
                    column="location"
                    label="Location"
                    className="hidden md:table-cell"
                    sortColumn={sortColumn}
                    sortDirection={sortDirection}
                    onSort={toggleSort}
                  />
                  <SortableHeader
                    column="status"
                    label="Status"
                    sortColumn={sortColumn}
                    sortDirection={sortDirection}
                    onSort={toggleSort}
                  />
                  <SortableHeader
                    column="created_at"
                    label="Created"
                    className="hidden md:table-cell"
                    sortColumn={sortColumn}
                    sortDirection={sortDirection}
                    onSort={toggleSort}
                  />
                  <TableHead>
                    <span className="sr-only">Actions</span>
                  </TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {alerts.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={6} className="text-center text-muted-foreground">
                      No alerts found.
                    </TableCell>
                  </TableRow>
                ) : (
                  sortedData(alerts).map((alert) => (
                    <AlertRow key={alert.id} alert={alert} />
                  ))
                )}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </TabsContent>
    </Tabs>
  );
}
