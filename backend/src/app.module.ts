import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { databaseConfig, jwtConfig } from './config';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { ContactsModule } from './modules/contacts/contacts.module';
import { ServicesModule } from './modules/services/services.module';
import { FirstAidModule } from './modules/first-aid/first-aid.module';
import { EmergencyTypesModule } from './modules/emergency-types/emergency-types.module';
import { EmergencyAlertsModule } from './modules/emergency-alerts/emergency-alerts.module';
import { UserLocationsModule } from './modules/user-locations/user-locations.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { AdminsModule } from './modules/admins/admins.module';
import { AnalyticsModule } from './modules/analytics/analytics.module';
import { AppController } from './app.controller';
import { IncidentTypesModule } from './modules/incident-types/incident-type.module';
import { EmergencyReportsModule } from './modules/emergency-reports/emergency-report.module';

@Module({
  imports: [
    IncidentTypesModule,
    EmergencyReportsModule,
    ConfigModule.forRoot({
      isGlobal: true,
      load: [databaseConfig, jwtConfig],
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
       useFactory: (config: ConfigService) => config.get('database')!,
    }),
    AuthModule,
    UsersModule,
    ContactsModule,
    ServicesModule,
    FirstAidModule,
    EmergencyTypesModule,
    EmergencyAlertsModule,
    UserLocationsModule,
    NotificationsModule,
    AdminsModule,
    AnalyticsModule,
  ],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: TransformInterceptor,
    },
  ],
})
export class AppModule {}
