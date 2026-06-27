'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Loader2, Send, X } from 'lucide-react';
import { sendNotificationAction } from '@/lib/api/notifications-actions';
import type { User } from '@/lib/api/types';

export function SendNotificationForm({ users }: { users: User[] }) {
  const router = useRouter();

  const [selectedIds, setSelectedIds] = useState<string[]>([]);
  const [title, setTitle] = useState('');
  const [body, setBody] = useState('');
  const [sendToAll, setSendToAll] = useState(false);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const selectedUsers = users.filter((u) => selectedIds.includes(u.id));

  function toggleUser(id: string) {
    setSelectedIds((prev) =>
      prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id],
    );
  }

  function toggleAll() {
    if (sendToAll) {
      setSendToAll(false);
      setSelectedIds([]);
    } else {
      setSendToAll(true);
      setSelectedIds(users.map((u) => u.id));
    }
  }

  async function handleSend() {
    if (!title.trim() || !body.trim()) {
      setError('Title and body are required.');
      return;
    }
    if (selectedIds.length === 0) {
      setError('Select at least one user.');
      return;
    }

    setError('');
    setSuccess('');
    setSending(true);

    try {
      await sendNotificationAction({
        userIds: selectedIds,
        title: title.trim(),
        body: body.trim(),
        broadcast: sendToAll,
      });
      setSuccess(`Notification sent to ${selectedIds.length} user(s).`);
      setTitle('');
      setBody('');
      setSelectedIds([]);
      setSendToAll(false);
      router.refresh();
    } catch (err) {
      setError(
        err instanceof Error ? err.message : 'Failed to send notification.',
      );
    } finally {
      setSending(false);
    }
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Send Notification</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        {/* Recipients */}
        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <Label>Recipients</Label>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              onClick={toggleAll}
            >
              {sendToAll ? 'Clear All' : 'Select All'}
            </Button>
          </div>

          {selectedUsers.length > 0 && (
            <div className="flex flex-wrap gap-1 mb-2">
              {selectedUsers.map((u) => (
                <Badge
                  key={u.id}
                  variant="secondary"
                  className="gap-1 cursor-pointer"
                  onClick={() => toggleUser(u.id)}
                >
                  {u.full_name || u.email || u.phone_number || u.id.slice(0, 8)}
                  <X className="h-3 w-3" />
                </Badge>
              ))}
            </div>
          )}

          <div className="max-h-40 overflow-y-auto border rounded-md divide-y">
            {users.length === 0 ? (
              <p className="text-sm text-muted-foreground p-3">No users found.</p>
            ) : (
              users.map((u) => (
                <label
                  key={u.id}
                  className={`flex items-center gap-2 p-2 cursor-pointer hover:bg-muted/50 text-sm ${
                    selectedIds.includes(u.id) ? 'bg-muted' : ''
                  }`}
                >
                  <input
                    type="checkbox"
                    checked={selectedIds.includes(u.id)}
                    onChange={() => toggleUser(u.id)}
                    className="rounded"
                  />
                  <span className="font-medium">
                    {u.full_name || 'Unnamed'}
                  </span>
                  <span className="text-muted-foreground text-xs">
                    {u.phone_number || u.email || ''}
                  </span>
                </label>
              ))
            )}
          </div>
        </div>

        {/* Title */}
        <div className="space-y-2">
          <Label htmlFor="notif-title">Title</Label>
          <Input
            id="notif-title"
            placeholder="e.g., Emergency Alert: Flood Warning"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            disabled={sending}
          />
        </div>

        {/* Body */}
        <div className="space-y-2">
          <Label htmlFor="notif-body">Message</Label>
          <textarea
            id="notif-body"
            className="flex min-h-24 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
            placeholder="Enter your emergency notification message..."
            value={body}
            onChange={(e) => setBody(e.target.value)}
            disabled={sending}
          />
        </div>

        {/* Feedback */}
        {error && (
          <p className="text-sm text-red-600 bg-red-50 border border-red-200 rounded-md p-2">
            {error}
          </p>
        )}
        {success && (
          <p className="text-sm text-green-600 bg-green-50 border border-green-200 rounded-md p-2">
            {success}
          </p>
        )}

        {/* Send button */}
        <Button
          onClick={handleSend}
          disabled={sending || selectedIds.length === 0}
          className="w-full"
        >
          {sending ? (
            <>
              <Loader2 className="h-4 w-4 mr-2 animate-spin" />
              Sending...
            </>
          ) : (
            <>
              <Send className="h-4 w-4 mr-2" />
              Send to {selectedIds.length} user{selectedIds.length !== 1 ? 's' : ''}
            </>
          )}
        </Button>
      </CardContent>
    </Card>
  );
}
