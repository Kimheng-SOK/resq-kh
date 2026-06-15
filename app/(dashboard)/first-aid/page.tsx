import { getTopics } from '@/lib/api/first-aid';
import { TopicsTable } from './topics-table';

export const dynamic = 'force-dynamic';

export default async function FirstAidPage() {
  const topics = await getTopics().catch(() => []);

  return <TopicsTable topics={topics} />;
}
