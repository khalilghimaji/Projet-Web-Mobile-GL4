import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { InjectRepository } from '@nestjs/typeorm';
@ApiTags('User')
@Controller('user')
export class UserController {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  @Get('rankings')
  @UseGuards(JwtAuthGuard)
  async getRankings() {
    return await this.userRepository.find({
      order: { score: 'DESC' },
      select: ['firstName', 'lastName', 'score', 'imageUrl'],
    });
  }
}
