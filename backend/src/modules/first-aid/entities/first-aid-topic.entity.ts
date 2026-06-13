import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { FirstAidStep } from './first-aid-step.entity';
import { FirstAidTranslation } from './first-aid-translation.entity';

export enum FirstAidSeverity {
  CRITICAL = 'critical',
  URGENT = 'urgent',
  STABLE = 'stable',
}

@Entity('first_aid_topics')
export class FirstAidTopic {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 100, unique: true })
  slug: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  icon_name: string | null;

  @Column({
    type: 'enum',
    enum: FirstAidSeverity,
    default: FirstAidSeverity.STABLE,
  })
  severity: FirstAidSeverity;

  @Column({ type: 'int', default: 0 })
  sort_order: number;

  @Column({ type: 'boolean', default: true })
  is_active: boolean;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updated_at: Date;

  @OneToMany(() => FirstAidStep, (step) => step.topic)
  steps: FirstAidStep[];

  @OneToMany(() => FirstAidTranslation, (translation) => translation.topic)
  translations: FirstAidTranslation[];
}
