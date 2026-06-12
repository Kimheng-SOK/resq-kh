import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';

@Injectable()
export class EmailService {
  private transporter: nodemailer.Transporter;

  constructor(
    private configService: ConfigService,
  ) {
    this.transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: this.configService.get('EMAIL_USER'),
        pass: this.configService.get('EMAIL_PASS'),
      },
    });
  }

  async sendOtp(
    email: string,
    otp: string,
  ) {
    await this.transporter.sendMail({
      from: this.configService.get('EMAIL_USER'),
      to: email,
      subject: 'RESQ Verification Code',
      text: `Your RESQ verification code is ${otp}`,
    });
  }
}