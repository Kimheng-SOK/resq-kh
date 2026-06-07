import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { EmergencyAlert } from '../../emergency-alerts/entities/emergency-alert.entity';

@Entity('user_locations')
export class UserLocation {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'uuid' })
  user_id!: string;

  @ManyToOne(() => User, (user) => user.locations, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user!: User;

  @Column({ type: 'decimal', precision: 9, scale: 6 })
  latitude!: string;

  @Column({ type: 'decimal', precision: 9, scale: 6 })
  longitude!: string;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  accuracy!: string | null;

  @Column({ type: 'timestamptz', default: () => 'CURRENT_TIMESTAMP' })
  captured_at!: Date;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at!: Date;

  @OneToMany(() => EmergencyAlert, (alert) => alert.location)
  emergency_alerts!: EmergencyAlert[];
}
