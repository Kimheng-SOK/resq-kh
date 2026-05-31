import { Body, Controller, Get, Param, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import { FirstAidService } from './first-aid.service';
import { CreateTopicDto } from './dto/create-topic.dto';
import { CreateStepDto } from './dto/create-step.dto';
import {
  CreateStepTranslationDto,
  CreateTopicTranslationDto,
} from './dto/create-translation.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { AdminRole } from '../admins/entities/admin.entity';

@ApiTags('first-aid')
@Controller('first-aid')
export class FirstAidController {
  constructor(private readonly firstAidService: FirstAidService) {}

  @Get('topics')
  @ApiQuery({ name: 'lang', required: false })
  findAllTopics(@Query('lang') lang?: string) {
    return this.firstAidService.findAllTopics(lang);
  }

  @Get('topics/:slug')
  @ApiQuery({ name: 'lang', required: false })
  findTopicBySlug(@Param('slug') slug: string, @Query('lang') lang?: string) {
    return this.firstAidService.findTopicBySlug(slug, lang);
  }

  @Post('topics')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR)
  @ApiBearerAuth()
  createTopic(@Body() dto: CreateTopicDto) {
    return this.firstAidService.createTopic(dto);
  }

  @Post('steps')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR)
  @ApiBearerAuth()
  createStep(@Body() dto: CreateStepDto) {
    return this.firstAidService.createStep(dto);
  }

  @Post('translations/topic')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR)
  @ApiBearerAuth()
  createTopicTranslation(@Body() dto: CreateTopicTranslationDto) {
    return this.firstAidService.createTopicTranslation(dto);
  }

  @Post('translations/step')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR)
  @ApiBearerAuth()
  createStepTranslation(@Body() dto: CreateStepTranslationDto) {
    return this.firstAidService.createStepTranslation(dto);
  }
}
