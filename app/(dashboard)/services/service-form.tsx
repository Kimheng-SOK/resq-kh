'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle
} from '@/components/ui/sheet';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { createServiceAction, updateServiceAction } from '@/lib/api/services-actions';
import type { Service } from '@/lib/api/types';

export function ServiceForm({
  service,
  open,
  onClose
}: {
  service: Service | null;
  open: boolean;
  onClose: () => void;
}) {
  const router = useRouter();
  const isEdit = !!service;
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError('');

    const formData = new FormData(e.currentTarget);
    const data = {
      name: formData.get('name') as string,
      category: formData.get('category') as string,
      phone_number: formData.get('phone_number') as string,
      address: (formData.get('address') as string) || undefined,
      latitude: formData.get('latitude')
        ? Number(formData.get('latitude'))
        : undefined,
      longitude: formData.get('longitude')
        ? Number(formData.get('longitude'))
        : undefined,
      description: (formData.get('description') as string) || undefined
    };

    try {
      if (isEdit) {
        await updateServiceAction(service.id, data);
      } else {
        await createServiceAction(data);
      }
      router.refresh();
      onClose();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save service.');
    } finally {
      setSaving(false);
    }
  }

  return (
    <Sheet open={open} onOpenChange={(o) => !o && onClose()}>
      <SheetContent side="right" className="sm:max-w-md overflow-y-auto">
        <SheetHeader>
          <SheetTitle>{isEdit ? 'Edit Service' : 'Add Service'}</SheetTitle>
          <SheetDescription>
            {isEdit
              ? 'Update the service details.'
              : 'Add a new emergency service.'}
          </SheetDescription>
        </SheetHeader>
        <form onSubmit={handleSubmit} className="mt-6 space-y-4">
          <div className="space-y-2">
            <Label htmlFor="name">Name *</Label>
            <Input
              id="name"
              name="name"
              defaultValue={service?.name || ''}
              required
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="category">Category *</Label>
            <Input
              id="category"
              name="category"
              defaultValue={service?.category || ''}
              placeholder="e.g. Hospital, Police, Fire Station"
              required
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="phone_number">Phone Number *</Label>
            <Input
              id="phone_number"
              name="phone_number"
              defaultValue={service?.phone_number || ''}
              required
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="address">Address</Label>
            <Input
              id="address"
              name="address"
              defaultValue={service?.address || ''}
            />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="latitude">Latitude</Label>
              <Input
                id="latitude"
                name="latitude"
                type="number"
                step="any"
                defaultValue={service?.latitude?.toString() || ''}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="longitude">Longitude</Label>
              <Input
                id="longitude"
                name="longitude"
                type="number"
                step="any"
                defaultValue={service?.longitude?.toString() || ''}
              />
            </div>
          </div>
          <div className="space-y-2">
            <Label htmlFor="description">Description</Label>
            <Input
              id="description"
              name="description"
              defaultValue={service?.description || ''}
            />
          </div>
          {error && <p className="text-sm text-destructive">{error}</p>}
          <div className="flex gap-2 justify-end">
            <Button type="button" variant="outline" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" disabled={saving}>
              {saving ? 'Saving...' : isEdit ? 'Update' : 'Create'}
            </Button>
          </div>
        </form>
      </SheetContent>
    </Sheet>
  );
}
