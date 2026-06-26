import { Injectable } from "@nestjs/common";
import { IncidentType } from "./entity/incident-type.entity";
import { InjectRepository } from "@nestjs/typeorm/dist/common/typeorm.decorators";
import { Repository } from "typeorm/repository/Repository.js";
import { CreateIncidentTypeDto } from "./dto/create-incident-type.dto";

@Injectable()
export class IncidentTypesService {
  constructor(
    @InjectRepository(IncidentType)
    private repo: Repository<IncidentType>,
  ) {}

  findAll() {
    return this.repo.find({ order: { sort_order: 'ASC' } });
  }

  create(dto: CreateIncidentTypeDto) {
    const type = this.repo.create(dto);
    return this.repo.save(type);
  }
}