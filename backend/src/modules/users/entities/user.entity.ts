import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Contact } from '../../contacts/entities/contact.entity';
import { EmergencyAlert } from '../../emergency-alerts/entities/emergency-alert.entity';
import { UserLocation } from '../../user-locations/entities/user-location.entity';
import { Notification } from '../../notifications/entities/notification.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id?: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  full_name?: string | null;

  @Column({ type: 'varchar', length: 255, nullable: true, unique: true })
  email?: string | null;

  @Column({ type: 'varchar', length: 50, nullable: true })
  phone_number?: string | null;

  @Column({ type: 'varchar', length: 10, nullable: true })
  blood_group?: string | null;

  @Column({ type: 'text', nullable: true })
  allergies?: string | null;

  @Column({ type: 'text', nullable: true })
  medical_conditions?: string | null;

  @Column({ type: 'varchar', length: 10, default: 'en' })
  preferred_language?: string;

  @Column({ type: 'varchar', length: 10, default: 'light' })
  dark_mode?: string;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at?: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updated_at?: Date;

  @OneToMany(() => Contact, (contact) => contact.user)
  contacts?: Contact[];

  @OneToMany(() => EmergencyAlert, (alert) => alert.user)
  emergency_alerts?: EmergencyAlert[];

  @OneToMany(() => UserLocation, (location) => location.user)
  locations?: UserLocation[];
}
