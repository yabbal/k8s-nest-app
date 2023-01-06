import { Injectable } from '@nestjs/common';
import { version } from '../package.json';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello Worlds!';
  }

  getVersion(): string {
    return version;
  }

  getBye(): string {
    return 'Bye Bye!';
  }
}
