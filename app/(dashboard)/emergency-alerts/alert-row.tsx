'use client';

import { useState } from 'react';
import { TableCell, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { MoreHorizontal, Loader2 } from 'lucide-react';
import { useRouter } from 'next/navigation';
import { updateAlertStatusAction } from '@/lib/api/emergency-alerts-actions';
import type { EmergencyAlert } from '@/lib/api/types';

const STATUS_STYLES: Record<string, string> = {
  active: 'bg-red-100 text-red-800 border-red-200',
  resolved: 'bg-green-100 text-green-800 border-green-200',
  cancelled: 'bg-gray-100 text-gray-800 border-gray-200',
};

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
}

export function AlertRow({ alert }: { alert: EmergencyAlert }) {
  const router = useRouter();
  const [saving, setSaving] = useState(false);

  async function handleStatusChange(status: 'resolved' | 'cancelled') {
    setSaving(true);
    try {
      await updateAlertStatusAction(alert.id, status);
      router.refresh();
    } catch (err) {
      console.error('Failed to update alert status:', err);
    } finally {
      setSaving(false);
    }
  }

  return (
    <TableRow className={saving ? 'opacity-50 pointer-events-none' : ''}>
      <TableCell className="font-medium">
        {alert.user?.full_name || alert.user?.phone_number || 'Unknown'}
      </TableCell>
      <TableCell>
        <Badge variant="outline">
          {alert.emergency_type?.label || 'N/A'}
        </Badge>
      </TableCell>
      <TableCell className="hidden md:table-cell">
        {alert.location
          ? `${Number(alert.location.latitude).toFixed(4)}, ${Number(alert.location.longitude).toFixed(4)}`
          : '—'}
      </TableCell>
      <TableCell>
        <Badge variant="outline" className={STATUS_STYLES[alert.status] || ''}>
          {alert.status}
        </Badge>
      </TableCell>
      <TableCell className="hidden md:table-cell">
        {formatDate(alert.created_at)}
      </TableCell>
      <TableCell>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button
              aria-haspopup="true"
              size="icon"
              variant="ghost"
              disabled={saving}
            >
              {saving ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <MoreHorizontal className="h-4 w-4" />
              )}
              <span className="sr-only">Toggle menu</span>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Actions</DropdownMenuLabel>
            <DropdownMenuItem
              onClick={() => router.push(`/emergency-alerts/${alert.id}`)}
            >
              View Details
            </DropdownMenuItem>
            {alert.status === 'active' && (
              <>
                <DropdownMenuSeparator />
                <DropdownMenuItem onClick={() => handleStatusChange('resolved')}>
                  Mark Resolved
                </DropdownMenuItem>
                <DropdownMenuItem
                  onClick={() => handleStatusChange('cancelled')}
                  className="text-red-600"
                >
                  Cancel Alert
                </DropdownMenuItem>
              </>
            )}
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
}
