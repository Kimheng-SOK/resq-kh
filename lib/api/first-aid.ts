import { api } from '@/lib/api-client';
import type { FirstAidTopic, FirstAidStep } from './types';

export function getTopics(lang?: string): Promise<FirstAidTopic[]> {
  return api.get<FirstAidTopic[]>('/first-aid/topics', lang ? { lang } : undefined);
}

export function getTopicBySlug(
  slug: string,
  lang?: string
): Promise<FirstAidTopic & { steps: FirstAidStep[] }> {
  return api.get<FirstAidTopic & { steps: FirstAidStep[] }>(
    `/first-aid/topics/${slug}`,
    lang ? { lang } : undefined
  );
}

export function createTopic(data: {
  slug: string;
  icon_name?: string;
  severity?: string;
  sort_order?: number;
}): Promise<FirstAidTopic> {
  return api.post<FirstAidTopic>('/first-aid/topics', data);
}

export function createStep(data: {
  topic_id: string;
  step_number: number;
  is_warning?: boolean;
  image_url?: string;
}): Promise<FirstAidStep> {
  return api.post<FirstAidStep>('/first-aid/steps', data);
}

export function createTopicTranslation(data: {
  topic_id: string;
  language_code: string;
  title: string;
  summary?: string;
}): Promise<unknown> {
  return api.post('/first-aid/translations/topic', data);
}

export function createStepTranslation(data: {
  step_id: string;
  language_code: string;
  instruction: string;
}): Promise<unknown> {
  return api.post('/first-aid/translations/step', data);
}
