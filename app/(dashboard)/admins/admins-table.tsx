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
import { Button } from '@/components/ui/button';
import { PlusCircle } from 'lucide-react';
import type { AdminUser } from '@/lib/api/types';
import { useSort } from '@/lib/hooks/use-sort';
import { SortableHeader } from '@/components/ui/sortable-header';
import { AdminRow } from './admin-row';
import { AdminForm } from './admin-form';

export function AdminsTable({ admins }: { admins: AdminUser[] }) {
  const [formOpen, setFormOpen] = useState(false);
  const [editingAdmin, setEditingAdmin] = useState<AdminUser | null>(null);
  const { sortColumn, sortDirection, toggleSort, sortedData } =
    useSort('full_name');

  function handleEdit(admin: AdminUser) {
    setEditingAdmin(admin);
    setFormOpen(true);
  }

  function handleCreate() {
    setEditingAdmin(null);
    setFormOpen(true);
  }

  function handleClose() {
    setFormOpen(false);
    setEditingAdmin(null);
  }

  return (
    <>
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Admins</CardTitle>
              <CardDescription>
                Manage admin accounts and their roles.
              </CardDescription>
            </div>
            <Button size="sm" className="h-8 gap-1" onClick={handleCreate}>
              <PlusCircle className="h-3.5 w-3.5" />
              <span className="hidden sm:inline">Add Admin</span>
            </Button>
          </div>
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
                  column="role"
                  label="Role"
                  sortColumn={sortColumn}
                  sortDirection={sortDirection}
                  onSort={toggleSort}
                />
                <SortableHeader
                  column="is_active"
                  label="Active"
                  className="hidden md:table-cell"
                  sortColumn={sortColumn}
                  sortDirection={sortDirection}
                  onSort={toggleSort}
                />
                <SortableHeader
                  column="last_login_at"
                  label="Last Login"
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
              {admins.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={6} className="text-center text-muted-foreground">
                    No admins found.
                  </TableCell>
                </TableRow>
              ) : (
                sortedData(admins).map((admin) => (
                  <AdminRow
                    key={admin.id}
                    admin={admin}
                    onEdit={() => handleEdit(admin)}
                  />
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {formOpen && (
        <AdminForm
          admin={editingAdmin}
          open={formOpen}
          onClose={handleClose}
        />
      )}
    </>
  );
}
