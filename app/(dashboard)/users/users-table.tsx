'use client';

'use client';

import { useState } from 'react';
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
import type { User } from '@/lib/api/types';
import { useSort } from '@/lib/hooks/use-sort';
import { SortableHeader } from '@/components/ui/sortable-header';
import { UserRow } from './user-row';
import { UserForm } from './user-form';

export function UsersTable({
  users,
  totalCount,
  canModify
}: {
  users: User[];
  totalCount: number;
  canModify: boolean;
}) {
  const { sortColumn, sortDirection, toggleSort, sortedData } =
    useSort('full_name');
  const [formOpen, setFormOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<User | null>(null);

  function handleEdit(user: User) {
    setEditingUser(user);
    setFormOpen(true);
  }

  function handleClose() {
    setFormOpen(false);
    setEditingUser(null);
  }

  return (
    <>
      <Card>
        <CardHeader>
          <CardTitle>Users</CardTitle>
          <CardDescription>
            {totalCount} registered user{totalCount !== 1 ? 's' : ''}.
            {users.length !== totalCount && ` Showing ${users.length} result${users.length !== 1 ? 's' : ''}.`}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <SortableHeader
                  column="full_name"
                  label="Name"
                  sortColumn={sortColumn}
                  sortDirection={sortDirection}
                  onSort={toggleSort}
                />
                <SortableHeader
                  column="email"
                  label="Email"
                  sortColumn={sortColumn}
                  sortDirection={sortDirection}
                  onSort={toggleSort}
                />
                <SortableHeader
                  column="phone_number"
                  label="Phone"
                  className="hidden md:table-cell"
                  sortColumn={sortColumn}
                  sortDirection={sortDirection}
                  onSort={toggleSort}
                />
                <SortableHeader
                  column="blood_group"
                  label="Blood Group"
                  className="hidden md:table-cell"
                  sortColumn={sortColumn}
                  sortDirection={sortDirection}
                  onSort={toggleSort}
                />
                <SortableHeader
                  column="preferred_language"
                  label="Language"
                  className="hidden lg:table-cell"
                  sortColumn={sortColumn}
                  sortDirection={sortDirection}
                  onSort={toggleSort}
                />
                <SortableHeader
                  column="created_at"
                  label="Created"
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
              {users.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="text-center text-muted-foreground">
                    No users found.
                  </TableCell>
                </TableRow>
              ) : (
                sortedData(users).map((user) => (
                  <UserRow
                    key={user.id}
                    user={user}
                    canModify={canModify}
                    onEdit={() => handleEdit(user)}
                  />
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {formOpen && editingUser && (
        <UserForm user={editingUser} open={formOpen} onClose={handleClose} />
      )}
    </>
  );
}
