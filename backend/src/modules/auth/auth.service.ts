import { BadRequestException, Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import * as bcrypt from 'bcryptjs';
import { Repository } from 'typeorm';
import { Admin } from '../admins/entities/admin.entity';
import { LoginDto } from './dto/login.dto';
import { User } from '../users/entities/user.entity';
import { OtpCode } from './entities/otp.entity';
import { SendOtpDto } from './dto/send-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(Admin)
    private adminRepository: Repository<Admin>,

    @InjectRepository(User)
    private userRepository: Repository<User>,

    @InjectRepository(OtpCode)
    private otpRepository: Repository<OtpCode>,

    private jwtService: JwtService,
  ) {}

  async login(dto: LoginDto) {
    const admin = await this.adminRepository
      .createQueryBuilder('admin')
      .addSelect('admin.password')
      .where('admin.email = :email', { email: dto.email })
      .getOne();

    if (!admin || !admin.is_active) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const valid = await bcrypt.compare(dto.password, admin.password);
    if (!valid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    admin.last_login_at = new Date();
    await this.adminRepository.save(admin);

    const payload = { sub: admin.id, email: admin.email, role: admin.role };
    return {
      access_token: this.jwtService.sign(payload),
      admin: {
        id: admin.id,
        email: admin.email,
        role: admin.role,
        full_name: admin.full_name,
      },
    };
  }

  getProfile(user: { id: string; email: string; role: string; full_name: string | null }) {
    return user;
  }

  private generateOtp(): string {
    return Math.floor(
      100000 + Math.random() * 900000,
    ).toString();
  }

  async sendOtp(dto: SendOtpDto) {
    let user = await this.userRepository.findOne({
      where: {
        phone_number: dto.phone_number,
      },
    });

    if (!user) {
      user = this.userRepository.create({
        full_name: dto.full_name,
        email: dto.email,
        phone_number: dto.phone_number,
      });

      await this.userRepository.save(user);
    }


    const recentOtp = await this.otpRepository.findOne({
      where: {
        phone_number: dto.phone_number,
        is_used: false,
      },
      order: {
        created_at: 'DESC',
      },
    });

    if (
      recentOtp &&
      recentOtp.expires_at > new Date()
    ) {
      throw new BadRequestException(
        'Please wait before requesting another OTP',
      );
    }


    const otp = this.generateOtp();

    const otpRecord = this.otpRepository.create({
      phone_number: dto.phone_number,
      otp_code: otp,
      expires_at: new Date(
        Date.now() + 5 * 60 * 1000, // 5 minutes
      ),
      is_used: false,
    });

    await this.otpRepository.save(otpRecord);

    return {
      message: 'OTP generated',
      otp,
      user_id: user.id,
    };
  }

  async verifyOtp(dto: VerifyOtpDto) {
    const otpRecord = await this.otpRepository.findOne({
      where: {
        phone_number: dto.phone_number,
        otp_code: dto.otp,
      },
      order: {
        created_at: 'DESC',
      },
    });

    if (!otpRecord) {
      throw new UnauthorizedException('Invalid OTP');
    }

    if (otpRecord.is_used) {
      throw new UnauthorizedException('OTP already used');
    }

    if (otpRecord.expires_at < new Date()) {
      throw new UnauthorizedException('OTP expired');
    }

    otpRecord.is_used = true;
    await this.otpRepository.save(otpRecord);

    const user = await this.userRepository.findOne({
      where: {
        phone_number: dto.phone_number,
      },
    });

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    user.is_phone_verified = true;
    await this.userRepository.save(user);
    
    const payload = {
      sub: user.id,
      phone_number: user.phone_number,
      role: 'user',
    };

    const accessToken = this.jwtService.sign(payload);

    return {
      message: 'OTP valid',
      access_token: accessToken,
      user: {
        id: user.id,
        full_name: user.full_name,
        email: user.email,
        phone_number: user.phone_number,
      },
    };
  }

}
