import { notFound } from 'next/navigation';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { getUser } from '@/lib/api/users';
import { getContacts } from '@/lib/api/contacts';
import { getReportsByUser } from '@/lib/api/emergency-reports';
import { getUserLocations } from '@/lib/api/user-locations';

export const dynamic = 'force-dynamic';

const REPORT_STATUS_STYLES: Record<string, string> = {
  pending: 'bg-amber-100 text-amber-800 border-amber-200',
  dispatched: 'bg-blue-100 text-blue-800 border-blue-200',
  resolved: 'bg-green-100 text-green-800 border-green-200',
};

export default async function UserDetailPage({
  params,
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

  const [contacts, reports, locations] = await Promise.all([
    getContacts(id).catch(() => []),
    getReportsByUser(id).catch(() => []),
    getUserLocations(id).catch(() => []),
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
            <p className="text-sm font-medium text-muted-foreground">
              Blood Group
            </p>
            <p>{user.blood_group || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">
              Allergies
            </p>
            <p>{user.allergies || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">
              Medical Conditions
            </p>
            <p>{user.medical_conditions || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">
              Language
            </p>
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
                  <TableHead className="hidden md:table-cell">
                    Relationship
                  </TableHead>
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

      {/* Emergency Reports */}
      <Card>
        <CardHeader>
          <CardTitle>Emergency Reports ({reports.length})</CardTitle>
        </CardHeader>
        <CardContent>
          {reports.length === 0 ? (
            <p className="text-sm text-muted-foreground">No reports submitted.</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Incident Type</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="hidden md:table-cell">
                    Description
                  </TableHead>
                  <TableHead className="hidden md:table-cell">Created</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {reports.map((r) => (
                  <TableRow key={r.id}>
                    <TableCell>
                      <Badge variant="outline">
                        {r.incidentType?.label || 'N/A'}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <Badge
                        variant="outline"
                        className={REPORT_STATUS_STYLES[r.status] || ''}
                      >
                        {r.status}
                      </Badge>
                    </TableCell>
                    <TableCell className="hidden md:table-cell max-w-64 truncate">
                      {r.description || '—'}
                    </TableCell>
                    <TableCell className="hidden md:table-cell">
                      {new Date(r.created_at).toLocaleString()}
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
            <p className="text-sm text-muted-foreground">
              No location data.
            </p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Latitude</TableHead>
                  <TableHead>Longitude</TableHead>
                  <TableHead className="hidden md:table-cell">
                    Accuracy
                  </TableHead>
                  <TableHead className="hidden md:table-cell">
                    Captured At
                  </TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {locations.slice(0, 10).map((loc) => (
                  <TableRow key={loc.id}>
                    <TableCell>{Number(loc.latitude).toFixed(6)}</TableCell>
                    <TableCell>{Number(loc.longitude).toFixed(6)}</TableCell>
                    <TableCell className="hidden md:table-cell">
                      {loc.accuracy
                        ? `${Number(loc.accuracy).toFixed(1)}m`
                        : '—'}
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
