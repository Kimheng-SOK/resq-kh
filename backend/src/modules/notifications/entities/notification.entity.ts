import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';

import { Service } from '../../services/entities/service.entity';
import { EmergencyReport } from '../../emergency-reports/entity/emergency-report.entity';
import { User } from '../../users/entities/user.entity';

export enum NotificationType {
  REPORT_ALERT = 'report_alert',
  ADMIN_BROADCAST = 'admin_broadcast',
  ADMIN_DIRECT = 'admin_direct',
}

@Entity('notifications')
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id?: string;

  @Column({ nullable: true })
  service_id?: string;

  @ManyToOne(() => Service, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'service_id' })
  service?: Service;

  @Column({ nullable: true })
  emergency_report_id?: string;

  @ManyToOne(() => EmergencyReport, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'emergency_report_id' })
  report?: EmergencyReport;

  @Column({ type: 'uuid', nullable: true })
  user_id?: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user?: User;

  @Column({
    type: 'enum',
    enum: NotificationType,
    default: NotificationType.REPORT_ALERT,
  })
  type?: NotificationType;

  @Column()
  title?: string;

  @Column('text')
  body?: string;

  @Column({ default: false })
  is_read?: boolean;

  @CreateDateColumn()
  created_at?: Date;
}
