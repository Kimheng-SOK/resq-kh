import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Contact } from './entities/contact.entity';
import { CreateContactDto } from './dto/create-contact.dto';
import { UpdateContactDto } from './dto/update-contact.dto';
import { UsersService } from '../users/users.service';

@Injectable()
export class ContactsService {
  constructor(
    @InjectRepository(Contact)
    private contactRepository: Repository<Contact>,
    private usersService: UsersService,
  ) {}

  async findAll(userId: string) {
    await this.usersService.findOne(userId);
    return this.contactRepository.find({
      where: { user_id: userId },
      order: { sort_order: 'ASC', created_at: 'ASC' },
    });
  }

  async findOne(userId: string, id: string) {
    const contact = await this.contactRepository.findOne({
      where: { id, user_id: userId },
    });
    if (!contact) {
      throw new NotFoundException(`Contact ${id} not found`);
    }
    return contact;
  }

  async create(userId: string, dto: CreateContactDto) {
    await this.usersService.findOne(userId);
    const contact = this.contactRepository.create({ ...dto, user_id: userId });
    return this.contactRepository.save(contact);
  }

  async update(userId: string, id: string, dto: UpdateContactDto) {
    const contact = await this.findOne(userId, id);
    Object.assign(contact, dto);
    return this.contactRepository.save(contact);
  }

  async remove(userId: string, id: string) {
    const contact = await this.findOne(userId, id);
    await this.contactRepository.remove(contact);
    return { deleted: true };
  }
}
