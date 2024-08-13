import { Controller, Get } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly configService: ConfigService,
  ) {}

  @Get()
  getHello(): string {
    const envName = this.configService.get<string>('MY_ENV_NAME');
    return `hellooo devops..... and Heloooo ${envName}`;
  }
}
