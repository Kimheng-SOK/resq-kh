import { PartialType } from '@nestjs/swagger';
import { CreateEmergencyTypeDto } from './create-emergency-type.dto';

export class UpdateEmergencyTypeDto extends PartialType(CreateEmergencyTypeDto) {}
