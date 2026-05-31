import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserLocation } from './entities/user-location.entity';
import { UsersModule } from '../users/users.module';
import { UserLocationsController } from './user-locations.controller';
import { UserLocationsService } from './user-locations.service';

@Module({
  imports: [TypeOrmModule.forFeature([UserLocation]), UsersModule],
  controllers: [UserLocationsController],
  providers: [UserLocationsService],
})
export class UserLocationsModule {}
