import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EmergencyType } from './entities/emergency-type.entity';
import { EmergencyTypesController } from './emergency-types.controller';
import { EmergencyTypesService } from './emergency-types.service';

@Module({
  imports: [TypeOrmModule.forFeature([EmergencyType])],
  controllers: [EmergencyTypesController],
  providers: [EmergencyTypesService],
  exports: [EmergencyTypesService],
})
export class EmergencyTypesModule {}
