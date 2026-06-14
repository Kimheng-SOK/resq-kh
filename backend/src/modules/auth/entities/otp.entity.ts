import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity('otp_codes')
export class OtpCode {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  phone_number: string | null;

  @Column({ type: 'varchar', length: 255, nullable: true })
  email: string | null;

  @Column({ type: 'varchar', length: 10 })
  otp_code!: string;

  @Column({ type: 'timestamptz' })
  expires_at!: Date;

  @Column({ default: false })
  is_used!: boolean;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at!: Date;
}