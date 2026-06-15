'use client';

import { ArrowUp, ArrowDown } from 'lucide-react';
import { TableHead } from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';
import type { SortDirection } from '@/lib/hooks/use-sort';

interface SortableHeaderProps {
  column: string;
  label: string;
  sortColumn: string | null;
  sortDirection: SortDirection;
  onSort: (column: string) => void;
  className?: string;
}

export function SortableHeader({
  column,
  label,
  sortColumn,
  sortDirection,
  onSort,
  className
}: SortableHeaderProps) {
  const isActive = sortColumn === column;

  return (
    <TableHead className={className}>
      <Button
        variant="ghost"
        size="sm"
        className="-ml-3 h-8 gap-1 font-medium"
        onClick={() => onSort(column)}
      >
        {label}
        {isActive && sortDirection === 'asc' && (
          <ArrowUp className="h-3.5 w-3.5" />
        )}
        {isActive && sortDirection === 'desc' && (
          <ArrowDown className="h-3.5 w-3.5" />
        )}
      </Button>
    </TableHead>
  );
}
