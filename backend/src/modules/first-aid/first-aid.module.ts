import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FirstAidTopic } from './entities/first-aid-topic.entity';
import { FirstAidStep } from './entities/first-aid-step.entity';
import { FirstAidTranslation } from './entities/first-aid-translation.entity';
import { FirstAidStepTranslation } from './entities/first-aid-step-translation.entity';
import { FirstAidController } from './first-aid.controller';
import { FirstAidService } from './first-aid.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      FirstAidTopic,
      FirstAidStep,
      FirstAidTranslation,
      FirstAidStepTranslation,
    ]),
  ],
  controllers: [FirstAidController],
  providers: [FirstAidService],
})
export class FirstAidModule {}
