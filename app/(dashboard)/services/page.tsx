import { getServices } from '@/lib/api/services';
import { getSession } from '@/lib/session';
import { ServicesTable } from './services-table';

export const dynamic = 'force-dynamic';

export default async function ServicesPage() {
  const session = await getSession();
  const services = await getServices().catch(() => []);

  const canModify =
    session?.role === 'super_admin' || session?.role === 'moderator';

  return <ServicesTable services={services} canModify={canModify} />;
}
