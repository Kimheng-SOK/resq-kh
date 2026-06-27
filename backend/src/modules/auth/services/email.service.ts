import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private _transporter: nodemailer.Transporter | null = null;

  constructor(
    private configService: ConfigService,
  ) {}

  private get transporter(): nodemailer.Transporter {
    if (!this._transporter) {
      this._transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: this.configService.get('EMAIL_USER'),
          pass: this.configService.get('EMAIL_PASS'),
        },
      });
    }
    return this._transporter;
  }

  async sendOtp(
    email: string,
    otp: string,
  ) {
    const user = this.configService.get('EMAIL_USER');
    if (!user) {
      this.logger.warn('EMAIL_USER not configured — skipping email send');
      return;
    }
    await this.transporter.sendMail({
      from: user,
      to: email,
      subject: 'RESQ Verification Code',
      text: `Your RESQ verification code is ${otp}`,
    });
  }
}
