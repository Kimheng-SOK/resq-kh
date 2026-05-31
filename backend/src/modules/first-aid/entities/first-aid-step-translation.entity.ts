import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  Unique,
  UpdateDateColumn,
} from 'typeorm';
import { FirstAidStep } from './first-aid-step.entity';

@Entity('first_aid_step_translations')
@Unique(['step_id', 'language_code'])
export class FirstAidStepTranslation {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid' })
  step_id: string;

  @ManyToOne(() => FirstAidStep, (step) => step.translations, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'step_id' })
  step: FirstAidStep;

  @Column({ type: 'varchar', length: 10 })
  language_code: string;

  @Column({ type: 'text' })
  instruction: string;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updated_at: Date;
}
