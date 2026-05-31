import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { ContactsService } from './contacts.service';
import { CreateContactDto } from './dto/create-contact.dto';
import { UpdateContactDto } from './dto/update-contact.dto';

@ApiTags('contacts')
@Controller('users/:userId/contacts')
export class ContactsController {
  constructor(private readonly contactsService: ContactsService) {}

  @Get()
  findAll(@Param('userId', ParseUUIDPipe) userId: string) {
    return this.contactsService.findAll(userId);
  }

  @Get(':id')
  findOne(
    @Param('userId', ParseUUIDPipe) userId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.contactsService.findOne(userId, id);
  }

  @Post()
  create(
    @Param('userId', ParseUUIDPipe) userId: string,
    @Body() dto: CreateContactDto,
  ) {
    return this.contactsService.create(userId, dto);
  }

  @Patch(':id')
  update(
    @Param('userId', ParseUUIDPipe) userId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateContactDto,
  ) {
    return this.contactsService.update(userId, id, dto);
  }

  @Delete(':id')
  remove(
    @Param('userId', ParseUUIDPipe) userId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.contactsService.remove(userId, id);
  }
}
