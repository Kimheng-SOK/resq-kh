'use client';

import { TableCell, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu';
import { MoreHorizontal } from 'lucide-react';
import { useRouter } from 'next/navigation';
import { deleteAdminAction } from '@/lib/api/admins-actions';
import type { AdminUser } from '@/lib/api/types';

const ROLE_STYLES: Record<string, string> = {
  super_admin: 'bg-purple-100 text-purple-800',
  moderator: 'bg-blue-100 text-blue-800',
  viewer: 'bg-gray-100 text-gray-800'
};

function formatDate(dateStr: string | null): string {
  if (!dateStr) return 'Never';
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
}

export function AdminRow({
  admin,
  onEdit
}: {
  admin: AdminUser;
  onEdit: () => void;
}) {
  const router = useRouter();

  async function handleDelete() {
    try {
      await deleteAdminAction(admin.id);
      router.refresh();
    } catch (err) {
      console.error('Failed to delete admin:', err);
    }
  }

  return (
    <TableRow>
      <TableCell className="font-medium">
        {admin.full_name || '—'}
      </TableCell>
      <TableCell>{admin.email}</TableCell>
      <TableCell>
        <Badge variant="outline" className={ROLE_STYLES[admin.role] || ''}>
          {admin.role.replace('_', ' ')}
        </Badge>
      </TableCell>
      <TableCell className="hidden md:table-cell">
        <Badge
          variant="outline"
          className={
            admin.is_active
              ? 'bg-green-100 text-green-800'
              : 'bg-red-100 text-red-800'
          }
        >
          {admin.is_active ? 'Yes' : 'No'}
        </Badge>
      </TableCell>
      <TableCell className="hidden lg:table-cell">
        {formatDate(admin.last_login_at)}
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
            <DropdownMenuItem onClick={onEdit}>Edit</DropdownMenuItem>
            <DropdownMenuItem
              className="text-destructive"
              onClick={handleDelete}
            >
              Delete
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
}
