'use client';

import { useState, useCallback, useMemo } from 'react';

export type SortDirection = 'asc' | 'desc' | null;

export interface SortState {
  column: string | null;
  direction: SortDirection;
}

function getValue(obj: unknown, column: string): string {
  const value = (obj as Record<string, unknown>)[column];

  if (value === null || value === undefined) return '';

  // Handle arrays — sort by length (e.g. steps, translations count)
  if (Array.isArray(value)) {
    return String(value.length).padStart(6, '0');
  }

  // Handle nested objects (e.g. alert.user.full_name, alert.emergency_type.label)
  if (typeof value === 'object') {
    const nested = value as Record<string, unknown>;
    return String(nested.full_name ?? nested.name ?? nested.label ?? nested.slug ?? '');
  }

  return String(value);
}

export function useSort(defaultColumn?: string) {
  const [sort, setSort] = useState<SortState>({
    column: defaultColumn ?? null,
    direction: 'asc'
  });

  const toggleSort = useCallback((column: string) => {
    setSort((prev) => {
      if (prev.column !== column) return { column, direction: 'asc' };
      if (prev.direction === 'asc') return { column, direction: 'desc' };
      return { column: null, direction: null };
    });
  }, []);

  const sortedData = useCallback(
    <T>(data: T[], column: string | null = sort.column): T[] => {
      if (!column || !sort.direction) return data;

      return [...data].sort((a, b) => {
        const aVal = getValue(a, column);
        const bVal = getValue(b, column);

        const cmp = aVal.localeCompare(bVal, undefined, {
          numeric: true,
          sensitivity: 'base'
        });

        return sort.direction === 'asc' ? cmp : -cmp;
      });
    },
    [sort]
  );

  return useMemo(
    () => ({
      sortColumn: sort.column,
      sortDirection: sort.direction,
      toggleSort,
      sortedData
    }),
    [sort, toggleSort, sortedData]
  );
}
