import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { IncidentType } from '../../incident-types/entity/incident-type.entity';
import { User } from '../../users/entities/user.entity';

export enum ReportStatus {
  PENDING = 'pending',
  DISPATCHED = 'dispatched',
  RESOLVED = 'resolved',
}

@Entity('emergency_reports')
export class EmergencyReport {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid' })
  user_id: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ type: 'uuid' })
  incident_type_id: string;

  @ManyToOne(() => IncidentType, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'incident_type_id' })
  incidentType: IncidentType;

  @Column({ type: 'varchar', length: 150 })
  reporter_name: string;

  @Column({ type: 'varchar', length: 30 })
  reporter_phone: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ type: 'decimal', precision: 10, scale: 6, nullable: true })
  latitude: number | null;

  @Column({ type: 'decimal', precision: 10, scale: 6, nullable: true })
  longitude: number | null;

  @Column({
    type: 'enum',
    enum: ReportStatus,
    default: ReportStatus.PENDING,
  })
  status: ReportStatus;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updated_at: Date;
}