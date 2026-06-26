import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { IncidentType } from "./entity/incident-type.entity";
import { IncidentTypesController } from "./incident-type.controller";
import { IncidentTypesService } from "./incident-type.service";
@Module({
  imports: [TypeOrmModule.forFeature([IncidentType])],
  controllers: [IncidentTypesController],
  providers: [IncidentTypesService],
})
export class IncidentTypesModule {}