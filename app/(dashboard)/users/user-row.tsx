'use client';

import { TableCell, TableRow } from '@/components/ui/table';
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
import { deleteUserAction } from '@/lib/api/users-actions';
import type { User } from '@/lib/api/types';

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  });
}

export function UserRow({
  user,
  canModify,
  onEdit
}: {
  user: User;
  canModify: boolean;
  onEdit: () => void;
}) {
  const router = useRouter();

  async function handleDelete() {
    try {
      await deleteUserAction(user.id);
      router.refresh();
    } catch (err) {
      console.error('Failed to delete user:', err);
    }
  }

  return (
    <TableRow>
      <TableCell className="font-medium">
        {user.full_name || '—'}
      </TableCell>
      <TableCell>{user.email || '—'}</TableCell>
      <TableCell className="hidden md:table-cell">
        {user.phone_number || '—'}
      </TableCell>
      <TableCell className="hidden md:table-cell">
        {user.blood_group || '—'}
      </TableCell>
      <TableCell className="hidden lg:table-cell">
        {user.preferred_language?.toUpperCase() || 'EN'}
      </TableCell>
      <TableCell className="hidden lg:table-cell">
        {user.created_at ? formatDate(user.created_at) : '—'}
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
            <DropdownMenuItem
              onClick={() => router.push(`/users/${user.id}`)}
            >
              View Details
            </DropdownMenuItem>
            {canModify && (
              <>
                <DropdownMenuItem onClick={onEdit}>Edit</DropdownMenuItem>
                <DropdownMenuItem
                  className="text-destructive"
                  onClick={handleDelete}
                >
                  Delete
                </DropdownMenuItem>
              </>
            )}
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
}
