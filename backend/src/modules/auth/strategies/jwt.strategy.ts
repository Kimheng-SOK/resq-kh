import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { InjectRepository } from '@nestjs/typeorm';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { Repository } from 'typeorm';
import { Admin } from '../../admins/entities/admin.entity';
import { User } from '../../users/entities/user.entity';

export interface JwtPayload {
  sub: string;
  email?: string;
  phone_number?: string;
  role: string;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    configService: ConfigService,
    @InjectRepository(Admin)
    private adminRepository: Repository<Admin>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('jwt.secret') ?? 'your-super-secret-key',
    });
  }

  async validate(payload: JwtPayload) {
    if (payload.role === 'user') {
      const user = await this.userRepository.findOne({
        where: { id: payload.sub },
      });
      if (!user) {
        throw new UnauthorizedException();
      }
      return {
        id: user.id,
        phone_number: user.phone_number,
        role: 'user',
        full_name: user.full_name,
      };
    }

    const admin = await this.adminRepository.findOne({
      where: { id: payload.sub, is_active: true },
    });
    if (!admin) {
      throw new UnauthorizedException();
    }
    return {
      id: admin.id,
      email: admin.email,
      role: admin.role,
      full_name: admin.full_name,
    };
  }
}
