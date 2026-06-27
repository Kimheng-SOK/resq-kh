import { Controller, Get, Post, Patch, Delete, Param, Body } from "@nestjs/common";
import { IncidentTypesService } from "./incident-type.service";
import { CreateIncidentTypeDto } from "./dto/create-incident-type.dto";

@Controller('incident-types')
export class IncidentTypesController {
  constructor(private readonly service: IncidentTypesService) {}

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Post()
  create(@Body() dto: CreateIncidentTypeDto) {
    return this.service.create(dto);
  }
}