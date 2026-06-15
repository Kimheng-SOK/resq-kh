import { notFound } from 'next/navigation';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table';
import { getTopicBySlug } from '@/lib/api/first-aid';

export const dynamic = 'force-dynamic';

const SEVERITY_STYLES: Record<string, string> = {
  critical: 'bg-red-100 text-red-800',
  urgent: 'bg-amber-100 text-amber-800',
  stable: 'bg-green-100 text-green-800'
};

export default async function TopicDetailPage({
  params
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  let topic;
  try {
    topic = await getTopicBySlug(slug);
  } catch {
    notFound();
  }

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <div className="flex items-center gap-3">
            <CardTitle className="capitalize">{slug.replace(/-/g, ' ')}</CardTitle>
            <Badge
              variant="outline"
              className={SEVERITY_STYLES[topic.severity] || ''}
            >
              {topic.severity}
            </Badge>
          </div>
        </CardHeader>
        <CardContent className="grid gap-4 md:grid-cols-4">
          <div>
            <p className="text-sm font-medium text-muted-foreground">Icon</p>
            <p>{topic.icon_name || '—'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Sort Order</p>
            <p>{topic.sort_order}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">Active</p>
            <p>{topic.is_active ? 'Yes' : 'No'}</p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">
              Translations
            </p>
            <p>{topic.translations?.length || 0} language(s)</p>
          </div>
        </CardContent>
      </Card>

      {/* Steps */}
      <Card>
        <CardHeader>
          <CardTitle>Steps ({topic.steps?.length || 0})</CardTitle>
        </CardHeader>
        <CardContent>
          {!topic.steps?.length ? (
            <p className="text-sm text-muted-foreground">No steps defined.</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-16">#</TableHead>
                  <TableHead>Instruction</TableHead>
                  <TableHead className="hidden md:table-cell">Warning</TableHead>
                  <TableHead className="hidden md:table-cell">Image</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {topic.steps
                  .sort((a, b) => a.step_number - b.step_number)
                  .map((step) => (
                    <TableRow key={step.id}>
                      <TableCell>{step.step_number}</TableCell>
                      <TableCell>
                        {step.translations?.[0]?.instruction || '—'}
                      </TableCell>
                      <TableCell className="hidden md:table-cell">
                        {step.is_warning ? (
                          <Badge variant="outline" className="bg-red-100 text-red-800">
                            Warning
                          </Badge>
                        ) : (
                          '—'
                        )}
                      </TableCell>
                      <TableCell className="hidden md:table-cell">
                        {step.image_url || '—'}
                      </TableCell>
                    </TableRow>
                  ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>

      {/* Translations */}
      {topic.translations?.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle>Topic Translations</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Language</TableHead>
                  <TableHead>Title</TableHead>
                  <TableHead className="hidden md:table-cell">Summary</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {topic.translations.map((t) => (
                  <TableRow key={t.id}>
                    <TableCell className="font-medium">
                      {t.language_code.toUpperCase()}
                    </TableCell>
                    <TableCell>{t.title}</TableCell>
                    <TableCell className="hidden md:table-cell">
                      {t.summary || '—'}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
