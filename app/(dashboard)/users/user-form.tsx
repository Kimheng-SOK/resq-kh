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
import { updateUserAction } from '@/lib/api/users-actions';
import type { User } from '@/lib/api/types';

export function UserForm({
  user,
  open,
  onClose
}: {
  user: User;
  open: boolean;
  onClose: () => void;
}) {
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError('');

    const formData = new FormData(e.currentTarget);
    const data = {
      full_name: (formData.get('full_name') as string) || undefined,
      phone_number: (formData.get('phone_number') as string) || undefined,
      blood_group: (formData.get('blood_group') as string) || undefined,
      allergies: (formData.get('allergies') as string) || undefined,
      medical_conditions:
        (formData.get('medical_conditions') as string) || undefined,
      preferred_language:
        (formData.get('preferred_language') as string) || undefined
    };

    try {
      await updateUserAction(user.id, data);
      router.refresh();
      onClose();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save user.');
    } finally {
      setSaving(false);
    }
  }

  return (
    <Sheet open={open} onOpenChange={(o) => !o && onClose()}>
      <SheetContent side="right" className="sm:max-w-md overflow-y-auto">
        <SheetHeader>
          <SheetTitle>Edit User</SheetTitle>
          <SheetDescription>
            Update {user.full_name || user.email || user.phone_number}&apos;s
            profile details.
          </SheetDescription>
        </SheetHeader>
        <form onSubmit={handleSubmit} className="mt-6 space-y-4">
          <div className="space-y-2">
            <Label htmlFor="full_name">Full Name</Label>
            <Input
              id="full_name"
              name="full_name"
              defaultValue={user.full_name || ''}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="phone_number">Phone Number</Label>
            <Input
              id="phone_number"
              name="phone_number"
              defaultValue={user.phone_number || ''}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="blood_group">Blood Group</Label>
            <Input
              id="blood_group"
              name="blood_group"
              defaultValue={user.blood_group || ''}
              placeholder="e.g. A+, O-"
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="allergies">Allergies</Label>
            <Input
              id="allergies"
              name="allergies"
              defaultValue={user.allergies || ''}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="medical_conditions">Medical Conditions</Label>
            <Input
              id="medical_conditions"
              name="medical_conditions"
              defaultValue={user.medical_conditions || ''}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="preferred_language">Preferred Language</Label>
            <Input
              id="preferred_language"
              name="preferred_language"
              defaultValue={user.preferred_language || 'en'}
              placeholder="en"
              maxLength={10}
            />
          </div>
          {error && <p className="text-sm text-destructive">{error}</p>}
          <div className="flex gap-2 justify-end">
            <Button type="button" variant="outline" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" disabled={saving}>
              {saving ? 'Saving...' : 'Update'}
            </Button>
          </div>
        </form>
      </SheetContent>
    </Sheet>
  );
}
