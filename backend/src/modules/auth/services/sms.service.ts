import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Twilio from 'twilio';

@Injectable()
export class SmsService {
  private client: Twilio.Twilio;

  constructor(
    private configService: ConfigService,
  ) {
    this.client = Twilio(
      this.configService.get<string>('TWILIO_ACCOUNT_SID'),
      this.configService.get<string>('TWILIO_AUTH_TOKEN'),
    );
  }

  async sendOtp(
    phoneNumber: string,
    otp: string,
  ) {
    await this.client.messages.create({
      body: `Your RESQ verification code is ${otp}`,
      from: this.configService.get<string>(
        'TWILIO_PHONE_NUMBER',
      ),
      to: phoneNumber,
    });
  }
}