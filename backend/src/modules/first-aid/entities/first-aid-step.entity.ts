import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { FirstAidTopic } from './first-aid-topic.entity';
import { FirstAidStepTranslation } from './first-aid-step-translation.entity';

@Entity('first_aid_steps')
export class FirstAidStep {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid' })
  topic_id: string;

  @ManyToOne(() => FirstAidTopic, (topic) => topic.steps, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'topic_id' })
  topic: FirstAidTopic;

  @Column({ type: 'int' })
  step_number: number;

  @Column({ type: 'boolean', default: false })
  is_warning: boolean;

  @Column({ type: 'varchar', length: 500, nullable: true })
  image_url: string | null;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updated_at: Date;

  @OneToMany(() => FirstAidStepTranslation, (t) => t.step)
  translations: FirstAidStepTranslation[];
}
