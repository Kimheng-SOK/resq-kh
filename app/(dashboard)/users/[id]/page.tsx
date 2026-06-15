import { notFound } from 'next/navigation';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { getUser } from '@/lib/api/users';
import { getContacts } from '@/lib/api/contacts';
import { getAlerts } from '@/lib/api/emergency-alerts';
import { getUserLocations } from '@/lib/api/user-locations';

export const dynamic = 'force-dynamic';

export default async function UserDetailPage({
  params
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  let user;
  try {
    user = await getUser(id);
  } catch {
    notFound();
  }

  const [contacts, alerts, locations] = await Promise.all([
    getContacts(id).catch(() => []),
    getAlerts({ userId: id }).catch(() => []),
    getUserLocations(id).catch(() => [])
  ]);

  return (
    <div className="space-y-6">
      {/* User Info */}
      <Card>
        <CardHeader>
          <CardTitle>{user.full_name || 'Unknown User'}</CardTitle>
        </CardHeader>
        <CardContent className="grid gap-4 md:grid-cols-3">
          <div>
            <p className="text-sm font-medium text-muted-foreground">Email</p>
            <p>{user.email || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Phone</p>
            <p>{user.phone_number || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Blood Group</p>
            <p>{user.blood_group || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Allergies</p>
            <p>{user.allergies || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Medical Conditions</p>
            <p>{user.medical_conditions || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Language</p>
            <p>{user.preferred_language?.toUpperCase() || 'EN'}</p>
          </div>
        </CardContent>
      </Card>

      {/* Emergency Contacts */}
      <Card>
        <CardHeader>
          <CardTitle>Emergency Contacts ({contacts.length})</CardTitle>
        </CardHeader>
        <CardContent>
          {contacts.length === 0 ? (
            <p className="text-sm text-muted-foreground">No contacts.</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Name</TableHead>
                  <TableHead>Phone</TableHead>
                  <TableHead className="hidden md:table-cell">Relationship</TableHead>
                  <TableHead className="hidden md:table-cell">Order</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {contacts.map((c) => (
                  <TableRow key={c.id}>
                    <TableCell className="font-medium">{c.name}</TableCell>
                    <TableCell>{c.phone_number}</TableCell>
                    <TableCell className="hidden md:table-cell">
                      {c.relationship || '—'}
                    </TableCell>
                    <TableCell className="hidden md:table-cell">
                      {c.sort_order}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>

      {/* Recent Alerts */}
      <Card>
        <CardHeader>
          <CardTitle>Emergency Alerts ({alerts.length})</CardTitle>
        </CardHeader>
        <CardContent>
          {alerts.length === 0 ? (
            <p className="text-sm text-muted-foreground">No alerts.</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Type</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="hidden md:table-cell">Created</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {alerts.slice(0, 10).map((a) => (
                  <TableRow key={a.id}>
                    <TableCell>{a.emergency_type?.label || 'N/A'}</TableCell>
                    <TableCell>
                      <Badge variant="outline">{a.status}</Badge>
                    </TableCell>
                    <TableCell className="hidden md:table-cell">
                      {new Date(a.created_at).toLocaleString()}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>

      {/* Location History */}
      <Card>
        <CardHeader>
          <CardTitle>Location History ({locations.length})</CardTitle>
        </CardHeader>
        <CardContent>
          {locations.length === 0 ? (
            <p className="text-sm text-muted-foreground">No location data.</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Latitude</TableHead>
                  <TableHead>Longitude</TableHead>
                  <TableHead className="hidden md:table-cell">Accuracy</TableHead>
                  <TableHead className="hidden md:table-cell">Captured At</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {locations.slice(0, 10).map((loc) => (
                  <TableRow key={loc.id}>
                    <TableCell>{Number(loc.latitude).toFixed(6)}</TableCell>
                    <TableCell>{Number(loc.longitude).toFixed(6)}</TableCell>
                    <TableCell className="hidden md:table-cell">
                      {loc.accuracy ? `${Number(loc.accuracy).toFixed(1)}m` : '—'}
                    </TableCell>
                    <TableCell className="hidden md:table-cell">
                      {new Date(loc.captured_at).toLocaleString()}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
