'use client';

import { TableCell, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { MoreHorizontal } from 'lucide-react';
import { useRouter } from 'next/navigation';
import { updateReportStatusAction, deleteReportAction } from '@/lib/api/emergency-reports-actions';
import type { EmergencyReport } from '@/lib/api/types';

const STATUS_STYLES: Record<string, string> = {
  pending: 'bg-amber-100 text-amber-800 border-amber-200',
  dispatched: 'bg-blue-100 text-blue-800 border-blue-200',
  resolved: 'bg-green-100 text-green-800 border-green-200',
};

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
}

export function ReportRow({ report }: { report: EmergencyReport }) {
  const router = useRouter();

  async function handleStatusChange(status: 'pending' | 'dispatched' | 'resolved') {
    try {
      await updateReportStatusAction(report.id, status);
      router.refresh();
    } catch (err) {
      console.error('Failed to update report status:', err);
    }
  }

  async function handleDelete() {
    try {
      await deleteReportAction(report.id);
      router.refresh();
    } catch (err) {
      console.error('Failed to delete report:', err);
    }
  }

  return (
    <TableRow>
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
      <TableCell className="hidden md:table-cell max-w-48 truncate">
        {report.description || '—'}
      </TableCell>
      <TableCell>
        <Badge
          variant="outline"
          className={STATUS_STYLES[report.status] || ''}
        >
          {report.status}
        </Badge>
      </TableCell>
      <TableCell className="hidden md:table-cell">
        {formatDate(report.created_at)}
      </TableCell>
      <TableCell>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button aria-haspopup="true" size="icon" variant="ghost">
              <MoreHorizontal className="h-4 w-4" />
              <span className="sr-only">Toggle menu</span>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Actions</DropdownMenuLabel>
            {report.status === 'pending' && (
              <DropdownMenuItem
                onClick={() => handleStatusChange('dispatched')}
              >
                Mark Dispatched
              </DropdownMenuItem>
            )}
            {report.status === 'dispatched' && (
              <DropdownMenuItem
                onClick={() => handleStatusChange('resolved')}
              >
                Mark Resolved
              </DropdownMenuItem>
            )}
            {report.status !== 'pending' && (
              <DropdownMenuItem
                onClick={() => handleStatusChange('pending')}
              >
                Reopen
              </DropdownMenuItem>
            )}
            <DropdownMenuItem
              onClick={handleDelete}
              className="text-red-600"
            >
              Delete Report
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
}
