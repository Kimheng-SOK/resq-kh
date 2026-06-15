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
import type { FirstAidTopic } from '@/lib/api/types';

const SEVERITY_STYLES: Record<string, string> = {
  critical: 'bg-red-100 text-red-800',
  urgent: 'bg-amber-100 text-amber-800',
  stable: 'bg-green-100 text-green-800'
};

export function TopicRow({ topic }: { topic: FirstAidTopic }) {
  const router = useRouter();

  return (
    <TableRow>
      <TableCell>
        <Badge
          variant="outline"
          className={SEVERITY_STYLES[topic.severity] || ''}
        >
          {topic.severity}
        </Badge>
      </TableCell>
      <TableCell className="font-medium">{topic.slug}</TableCell>
      <TableCell className="hidden md:table-cell">
        {topic.icon_name || '—'}
      </TableCell>
      <TableCell className="hidden md:table-cell">{topic.sort_order}</TableCell>
      <TableCell>
        <Badge
          variant="outline"
          className={
            topic.is_active
              ? 'bg-green-100 text-green-800'
              : 'bg-gray-100 text-gray-800'
          }
        >
          {topic.is_active ? 'Yes' : 'No'}
        </Badge>
      </TableCell>
      <TableCell className="hidden lg:table-cell">
        {topic.steps?.length || 0}
      </TableCell>
      <TableCell className="hidden lg:table-cell">
        {topic.translations?.length || 0}
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
              onClick={() => router.push(`/first-aid/${topic.slug}`)}
            >
              View Steps
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
}
