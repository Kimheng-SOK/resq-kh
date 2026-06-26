import { Entity } from "typeorm/decorator/entity/Entity.js";
import { PrimaryGeneratedColumn } from "typeorm/decorator/columns/PrimaryGeneratedColumn.js";
import { Column } from "typeorm/decorator/columns/Column.js";

@Entity('incident_types')
export class IncidentType {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 100, unique: true })
  slug: string;

  @Column({ type: 'varchar', length: 100 })
  label: string;

  @Column({ type: 'varchar', length: 100 })
  icon_name: string;

  @Column({ type: 'int', default: 0 })
  sort_order: number;

  @Column({ type: 'varchar', length: 50, nullable: true })
  recommended_responder: string | null; // 'fire' | 'police' | 'medical' | 'ambulance'
}