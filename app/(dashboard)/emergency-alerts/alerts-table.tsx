'use client';

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { useRouter } from 'next/navigation';
import type { EmergencyAlert } from '@/lib/api/types';
import { useSort } from '@/lib/hooks/use-sort';
import { SortableHeader } from '@/components/ui/sortable-header';
import { AlertRow } from './alert-row';

export function AlertsTable({
  alerts,
  totalCount,
  currentStatus,
  currentPage,
  totalPages,
}: {
  alerts: EmergencyAlert[];
  totalCount: number;
  currentStatus: string;
  currentPage: number;
  totalPages: number;
}) {
  const router = useRouter();
  const { sortColumn, sortDirection, toggleSort, sortedData } =
    useSort('created_at');

  function onTabChange(value: string) {
    router.push(`/emergency-alerts?status=${value}`);
  }

  function goToPage(p: number) {
    const params = new URLSearchParams();
    if (currentStatus !== 'all') params.set('status', currentStatus);
    if (p > 1) params.set('page', String(p));
    router.push(`/emergency-alerts${params.toString() ? `?${params}` : ''}`);
  }

  const activeCount =
    currentStatus === 'all'
      ? totalCount
      : undefined; // We don't have per-status totals from the paginated endpoint without extra calls

  return (
    <Tabs defaultValue={currentStatus} onValueChange={onTabChange}>
      <div className="flex items-center justify-between">
        <TabsList>
          <TabsTrigger value="all">All ({currentStatus === 'all' ? totalCount : '—'})</TabsTrigger>
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
                    <TableCell
                      colSpan={6}
                      className="text-center text-muted-foreground"
                    >
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

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="flex items-center justify-between pt-4">
                <p className="text-sm text-muted-foreground">
                  Page {currentPage} of {totalPages} ({totalCount} total)
                </p>
                <div className="flex items-center gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={currentPage <= 1}
                    onClick={() => goToPage(currentPage - 1)}
                  >
                    <ChevronLeft className="h-4 w-4" />
                    Previous
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={currentPage >= totalPages}
                    onClick={() => goToPage(currentPage + 1)}
                  >
                    Next
                    <ChevronRight className="h-4 w-4" />
                  </Button>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </TabsContent>
    </Tabs>
  );
}
