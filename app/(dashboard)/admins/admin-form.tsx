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
import { createAdminAction, updateAdminAction } from '@/lib/api/admins-actions';
import type { AdminUser } from '@/lib/api/types';

export function AdminForm({
  admin,
  open,
  onClose
}: {
  admin: AdminUser | null;
  open: boolean;
  onClose: () => void;
}) {
  const router = useRouter();
  const isEdit = !!admin;
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError('');

    const formData = new FormData(e.currentTarget);
    const data: Record<string, string | undefined> = {
      email: formData.get('email') as string,
      full_name: (formData.get('full_name') as string) || undefined,
      role: formData.get('role') as string
    };

    const password = formData.get('password') as string;
    if (password) {
      data.password = password;
    }

    try {
      if (isEdit) {
        await updateAdminAction(admin.id, data);
      } else {
        if (!password) {
          setError('Password is required for new admins.');
          setSaving(false);
          return;
        }
        await createAdminAction(data as { email: string; password: string; full_name?: string; role?: string });
      }
      router.refresh();
      onClose();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save admin.');
    } finally {
      setSaving(false);
    }
  }

  return (
    <Sheet open={open} onOpenChange={(o) => !o && onClose()}>
      <SheetContent side="right" className="sm:max-w-md overflow-y-auto">
        <SheetHeader>
          <SheetTitle>{isEdit ? 'Edit Admin' : 'Add Admin'}</SheetTitle>
          <SheetDescription>
            {isEdit
              ? 'Update the admin account details.'
              : 'Create a new admin account.'}
          </SheetDescription>
        </SheetHeader>
        <form onSubmit={handleSubmit} className="mt-6 space-y-4">
          <div className="space-y-2">
            <Label htmlFor="email">Email *</Label>
            <Input
              id="email"
              name="email"
              type="email"
              defaultValue={admin?.email || ''}
              required
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="full_name">Full Name</Label>
            <Input
              id="full_name"
              name="full_name"
              defaultValue={admin?.full_name || ''}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="password">
              {isEdit ? 'Password (leave blank to keep current)' : 'Password *'}
            </Label>
            <Input
              id="password"
              name="password"
              type="password"
              required={!isEdit}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="role">Role *</Label>
            <select
              id="role"
              name="role"
              className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
              defaultValue={admin?.role || 'viewer'}
            >
              <option value="super_admin">Super Admin</option>
              <option value="moderator">Moderator</option>
              <option value="viewer">Viewer</option>
            </select>
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
