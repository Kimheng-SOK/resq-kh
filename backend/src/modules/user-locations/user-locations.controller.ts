import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { ApiQuery, ApiTags } from '@nestjs/swagger';
import { UserLocationsService } from './user-locations.service';
import { CreateUserLocationDto } from './dto/create-user-location.dto';

@ApiTags('user-locations')
@Controller('user-locations')
export class UserLocationsController {
  constructor(private readonly userLocationsService: UserLocationsService) {}

  @Post()
  create(@Body() dto: CreateUserLocationDto) {
    return this.userLocationsService.create(dto);
  }

  @Get()
  @ApiQuery({ name: 'userId', required: true })
  findAll(@Query('userId') userId: string) {
    return this.userLocationsService.findAll(userId);
  }
}
