import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export default function MonitoringLoading() {
  return (
    <div className="space-y-4">
      <div>
        <div className="h-8 w-36 animate-pulse rounded-md bg-muted" />
        <div className="mt-2 h-5 w-64 animate-pulse rounded-md bg-muted" />
      </div>
      <Card>
        <CardHeader>
          <CardTitle className="text-sm font-medium">Activity Feed</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="divide-y divide-border">
            {Array.from({ length: 8 }).map((_, i) => (
              <div key={i} className="flex items-start gap-3 rounded-lg p-3">
                <div className="mt-0.5 h-8 w-8 shrink-0 animate-pulse rounded-full bg-muted" />
                <div className="flex-1 space-y-2">
                  <div className="h-4 w-3/4 animate-pulse rounded bg-muted" />
                  <div className="h-3 w-16 animate-pulse rounded bg-muted" />
                </div>
                <div className="h-5 w-16 animate-pulse rounded-full bg-muted" />
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
