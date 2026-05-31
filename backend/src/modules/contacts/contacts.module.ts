import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from '../users/users.module';
import { Contact } from './entities/contact.entity';
import { ContactsController } from './contacts.controller';
import { ContactsService } from './contacts.service';

@Module({
  imports: [TypeOrmModule.forFeature([Contact]), UsersModule],
  controllers: [ContactsController],
  providers: [ContactsService],
})
export class ContactsModule {}
