import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { EmergencyAlert } from '../../emergency-alerts/entities/emergency-alert.entity';

export enum NotificationType {
  SOS = 'sos',
  CONTACT_ALERT = 'contact_alert',
  SYSTEM = 'system',
  REMINDER = 'reminder',
}

@Entity('notifications')
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid' })
  user_id: string;

  @ManyToOne(() => User, (user) => user.notifications, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ type: 'uuid', nullable: true })
  emergency_alert_id: string | null;

  @ManyToOne(() => EmergencyAlert, (alert) => alert.notifications, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'emergency_alert_id' })
  emergency_alert: EmergencyAlert | null;

  @Column({ type: 'enum', enum: NotificationType })
  type: NotificationType;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  body: string;

  @Column({ type: 'boolean', default: false })
  is_read: boolean;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at: Date;
}
