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
import { User } from '../../users/entities/user.entity';
import { EmergencyType } from '../../emergency-types/entities/emergency-type.entity';
import { UserLocation } from '../../user-locations/entities/user-location.entity';
import { Notification } from '../../notifications/entities/notification.entity';

export enum EmergencyAlertStatus {
  ACTIVE = 'active',
  RESOLVED = 'resolved',
  CANCELLED = 'cancelled',
}

@Entity('emergency_alerts')
export class EmergencyAlert {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid' })
  user_id: string;

  @ManyToOne(() => User, (user) => user.emergency_alerts, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ type: 'uuid' })
  emergency_type_id: string;

  @ManyToOne(() => EmergencyType, (type) => type.emergency_alerts)
  @JoinColumn({ name: 'emergency_type_id' })
  emergency_type: EmergencyType;

  @Column({ type: 'uuid' })
  location_id: string;

  @ManyToOne(() => UserLocation, (location) => location.emergency_alerts)
  @JoinColumn({ name: 'location_id' })
  location: UserLocation;

  @Column({
    type: 'enum',
    enum: EmergencyAlertStatus,
    default: EmergencyAlertStatus.ACTIVE,
  })
  status: EmergencyAlertStatus;

  @Column({ type: 'text', nullable: true })
  notes: string | null;

  @Column({ type: 'timestamptz', nullable: true })
  resolved_at: Date | null;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updated_at: Date;

  @OneToMany(() => Notification, (notification) => notification.emergency_alert)
  notifications: Notification[];
}
