import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { FirstAidTopic } from './entities/first-aid-topic.entity';
import { FirstAidStep } from './entities/first-aid-step.entity';
import { FirstAidTranslation } from './entities/first-aid-translation.entity';
import { FirstAidStepTranslation } from './entities/first-aid-step-translation.entity';
import { CreateTopicDto } from './dto/create-topic.dto';
import { CreateStepDto } from './dto/create-step.dto';
import {
  CreateStepTranslationDto,
  CreateTopicTranslationDto,
} from './dto/create-translation.dto';

@Injectable()
export class FirstAidService {
  constructor(
    @InjectRepository(FirstAidTopic)
    private topicRepository: Repository<FirstAidTopic>,
    @InjectRepository(FirstAidStep)
    private stepRepository: Repository<FirstAidStep>,
    @InjectRepository(FirstAidTranslation)
    private topicTranslationRepository: Repository<FirstAidTranslation>,
    @InjectRepository(FirstAidStepTranslation)
    private stepTranslationRepository: Repository<FirstAidStepTranslation>,
  ) {}

  private filterByLang<T extends { language_code: string }>(
    items: T[],
    lang?: string,
  ): T[] {
    if (!lang) return items;
    return items.filter((i) => i.language_code === lang);
  }

  async findAllTopics(lang?: string) {
    const topics = await this.topicRepository.find({
      where: { is_active: true },
      relations: { translations: true },
      order: { sort_order: 'ASC' },
    });
    return topics.map((t) => ({
      ...t,
      translations: this.filterByLang(t.translations, lang),
    }));
  }

  async findTopicBySlug(slug: string, lang?: string) {
    const topic = await this.topicRepository.findOne({
      where: { slug, is_active: true },
      relations: {
        translations: true,
        steps: { translations: true },
      },
    });
    if (!topic) {
      throw new NotFoundException(`Topic ${slug} not found`);
    }
    return {
      ...topic,
      translations: this.filterByLang(topic.translations, lang),
      steps: topic.steps
        .sort((a, b) => a.step_number - b.step_number)
        .map((s) => ({
          ...s,
          translations: this.filterByLang(s.translations, lang),
        })),
    };
  }

  async createTopic(dto: CreateTopicDto) {
    const topic = this.topicRepository.create(dto);
    return this.topicRepository.save(topic);
  }

  async createStep(dto: CreateStepDto) {
    const step = this.stepRepository.create(dto);
    return this.stepRepository.save(step);
  }

  async createTopicTranslation(dto: CreateTopicTranslationDto) {
    const translation = this.topicTranslationRepository.create(dto);
    return this.topicTranslationRepository.save(translation);
  }

  async createStepTranslation(dto: CreateStepTranslationDto) {
    const translation = this.stepTranslationRepository.create(dto);
    return this.stepTranslationRepository.save(translation);
  }
}
