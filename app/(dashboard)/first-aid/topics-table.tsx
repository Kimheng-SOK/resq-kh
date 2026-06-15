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
import type { FirstAidTopic } from '@/lib/api/types';
import { useSort } from '@/lib/hooks/use-sort';
import { SortableHeader } from '@/components/ui/sortable-header';
import { TopicRow } from './topic-row';

export function TopicsTable({ topics }: { topics: FirstAidTopic[] }) {
  const { sortColumn, sortDirection, toggleSort, sortedData } =
    useSort('sort_order');

  return (
    <Card>
      <CardHeader>
        <CardTitle>First Aid Topics</CardTitle>
        <CardDescription>
          {topics.length} topic{topics.length !== 1 ? 's' : ''} available.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <SortableHeader
                column="severity"
                label="Severity"
                sortColumn={sortColumn}
                sortDirection={sortDirection}
                onSort={toggleSort}
              />
              <SortableHeader
                column="slug"
                label="Slug"
                sortColumn={sortColumn}
                sortDirection={sortDirection}
                onSort={toggleSort}
              />
              <SortableHeader
                column="icon_name"
                label="Icon"
                className="hidden md:table-cell"
                sortColumn={sortColumn}
                sortDirection={sortDirection}
                onSort={toggleSort}
              />
              <SortableHeader
                column="sort_order"
                label="Order"
                className="hidden md:table-cell"
                sortColumn={sortColumn}
                sortDirection={sortDirection}
                onSort={toggleSort}
              />
              <SortableHeader
                column="is_active"
                label="Active"
                sortColumn={sortColumn}
                sortDirection={sortDirection}
                onSort={toggleSort}
              />
              <SortableHeader
                column="steps"
                label="Steps"
                className="hidden lg:table-cell"
                sortColumn={sortColumn}
                sortDirection={sortDirection}
                onSort={toggleSort}
              />
              <SortableHeader
                column="translations"
                label="Translations"
                className="hidden lg:table-cell"
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
            {topics.length === 0 ? (
              <TableRow>
                <TableCell colSpan={8} className="text-center text-muted-foreground">
                  No topics found.
                </TableCell>
              </TableRow>
            ) : (
              sortedData(topics).map((topic) => (
                <TopicRow key={topic.id} topic={topic} />
              ))
            )}
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  );
}
