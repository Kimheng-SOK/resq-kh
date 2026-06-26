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

@Entity('notifications')
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id?: string;

  @Column()
  service_id?: string;

  @ManyToOne(() => Service, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'service_id' })
  service?: Service;

  @Column()
  emergency_report_id?: string;

  @ManyToOne(() => EmergencyReport, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'emergency_report_id' })
  report?: EmergencyReport;

  @Column()
  title?: string;

  @Column('text')
  body?: string;

  @Column({ default: false })
  is_read?: boolean;

  @CreateDateColumn()
  created_at?: Date;
}