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
    const users = await this.userRepository.find({
      order: { score: 'DESC' },
      select: ['id', 'firstName', 'lastName', 'email', 'score', 'imageUrl'],
    });

    // If no users exist, return some mock data for testing
    if (users.length === 0) {
      return [
        {
          id: '1',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          score: 100,
          imageUrl: null,
        },
        {
          id: '2',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          score: 80,
          imageUrl: null,
        },
        {
          id: '3',
          firstName: 'Jane',
          lastName: 'Smith',
          email: 'jane@example.com',
          score: 60,
          imageUrl: null,
        },
      ];
    }

    return users;
  }
}
