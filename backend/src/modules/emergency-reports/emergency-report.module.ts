import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EmergencyReport } from './entity/emergency-report.entity';
import { EmergencyReportsService } from './emergency-report.service';
import { EmergencyReportsController } from './emergency-report.controller';

@Module({
  imports: [TypeOrmModule.forFeature([EmergencyReport])],
  controllers: [EmergencyReportsController],
  providers: [EmergencyReportsService],
})
export class EmergencyReportsModule {}