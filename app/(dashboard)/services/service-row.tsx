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
import { deleteServiceAction } from '@/lib/api/services-actions';
import type { Service } from '@/lib/api/types';

export function ServiceRow({
  service,
  canModify,
  onEdit
}: {
  service: Service;
  canModify: boolean;
  onEdit: () => void;
}) {
  const router = useRouter();

  async function handleDelete() {
    try {
      await deleteServiceAction(service.id);
      router.refresh();
    } catch (err) {
      console.error('Failed to delete service:', err);
    }
  }

  return (
    <TableRow>
      <TableCell className="font-medium">{service.name}</TableCell>
      <TableCell>
        <Badge variant="outline">{service.category}</Badge>
      </TableCell>
      <TableCell className="hidden md:table-cell">
        {service.phone_number}
      </TableCell>
      <TableCell className="hidden lg:table-cell">
        {service.address || '—'}
      </TableCell>
      <TableCell>
        <Badge
          variant="outline"
          className={
            service.is_active
              ? 'bg-green-100 text-green-800'
              : 'bg-gray-100 text-gray-800'
          }
        >
          {service.is_active ? 'Yes' : 'No'}
        </Badge>
      </TableCell>
      {canModify && (
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
      )}
    </TableRow>
  );
}
