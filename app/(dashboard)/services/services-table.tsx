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
import type { Service } from '@/lib/api/types';
import { useSort } from '@/lib/hooks/use-sort';
import { SortableHeader } from '@/components/ui/sortable-header';
import { ServiceRow } from './service-row';
import { ServiceForm } from './service-form';

export function ServicesTable({
  services,
  canModify
}: {
  services: Service[];
  canModify: boolean;
}) {
  const [formOpen, setFormOpen] = useState(false);
  const [editingService, setEditingService] = useState<Service | null>(null);
  const { sortColumn, sortDirection, toggleSort, sortedData } =
    useSort('name');

  function handleEdit(service: Service) {
    setEditingService(service);
    setFormOpen(true);
  }

  function handleCreate() {
    setEditingService(null);
    setFormOpen(true);
  }

  function handleClose() {
    setFormOpen(false);
    setEditingService(null);
  }

  return (
    <>
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Services</CardTitle>
              <CardDescription>
                Emergency services listed in the app.
              </CardDescription>
            </div>
            {canModify && (
              <Button size="sm" className="h-8 gap-1" onClick={handleCreate}>
                <PlusCircle className="h-3.5 w-3.5" />
                <span className="hidden sm:inline">Add Service</span>
              </Button>
            )}
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <SortableHeader
                  column="name"
                  label="Name"
                  sortColumn={sortColumn}
                  sortDirection={sortDirection}
                  onSort={toggleSort}
                />
                <SortableHeader
                  column="category"
                  label="Category"
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
                  column="address"
                  label="Address"
                  className="hidden lg:table-cell"
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
                {canModify && (
                  <TableHead>
                    <span className="sr-only">Actions</span>
                  </TableHead>
                )}
              </TableRow>
            </TableHeader>
            <TableBody>
              {services.length === 0 ? (
                <TableRow>
                  <TableCell
                    colSpan={canModify ? 6 : 5}
                    className="text-center text-muted-foreground"
                  >
                    No services found.
                  </TableCell>
                </TableRow>
              ) : (
                sortedData(services).map((s) => (
                  <ServiceRow
                    key={s.id}
                    service={s}
                    canModify={canModify}
                    onEdit={() => handleEdit(s)}
                  />
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {formOpen && (
        <ServiceForm
          service={editingService}
          open={formOpen}
          onClose={handleClose}
        />
      )}
    </>
  );
}
