import { notFound } from 'next/navigation';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { getAlert } from '@/lib/api/emergency-alerts';
import Link from 'next/link';

export const dynamic = 'force-dynamic';

const STATUS_STYLES: Record<string, string> = {
  active: 'bg-red-100 text-red-800 border-red-200',
  resolved: 'bg-green-100 text-green-800 border-green-200',
  cancelled: 'bg-gray-100 text-gray-800 border-gray-200'
};

export default async function AlertDetailPage({
  params
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  let alert;
  try {
    alert = await getAlert(id);
  } catch {
    notFound();
  }

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Alert Details</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid gap-4 md:grid-cols-2">
            <div>
              <p className="text-sm font-medium text-muted-foreground">Status</p>
              <Badge variant="outline" className={STATUS_STYLES[alert.status] || ''}>
                {alert.status}
              </Badge>
            </div>
            <div>
              <p className="text-sm font-medium text-muted-foreground">Emergency Type</p>
              <p>{alert.emergency_type?.label || 'N/A'}</p>
            </div>
            <div>
              <p className="text-sm font-medium text-muted-foreground">Created</p>
              <p>{new Date(alert.created_at).toLocaleString()}</p>
            </div>
            <div>
              <p className="text-sm font-medium text-muted-foreground">Resolved</p>
              <p>{alert.resolved_at ? new Date(alert.resolved_at).toLocaleString() : '—'}</p>
            </div>
            {alert.notes && (
              <div className="md:col-span-2">
                <p className="text-sm font-medium text-muted-foreground">Notes</p>
                <p>{alert.notes}</p>
              </div>
            )}
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>User</CardTitle>
        </CardHeader>
        <CardContent className="grid gap-4 md:grid-cols-2">
          <div>
            <p className="text-sm font-medium text-muted-foreground">Name</p>
            <p>{alert.user?.full_name || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Phone</p>
            <p>{alert.user?.phone_number || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Email</p>
            <p>{alert.user?.email || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Blood Group</p>
            <p>{alert.user?.blood_group || '—'}</p>
          </div>
          <div className="md:col-span-2">
            <Link
              href={`/users/${alert.user_id}`}
              className="text-sm text-primary hover:underline"
            >
              View full user profile →
            </Link>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Location</CardTitle>
        </CardHeader>
        <CardContent className="grid gap-4 md:grid-cols-3">
          <div>
            <p className="text-sm font-medium text-muted-foreground">Latitude</p>
            <p>{alert.location ? Number(alert.location.latitude).toFixed(6) : '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Longitude</p>
            <p>{alert.location ? Number(alert.location.longitude).toFixed(6) : '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Accuracy</p>
            <p>
              {alert.location?.accuracy
                ? `${Number(alert.location.accuracy).toFixed(1)}m`
                : '—'}
            </p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
