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
      select: [
        'id',
        'firstName',
        'lastName',
        'email',
        'password',
        'imageUrl',
        'isEmailVerified',
        'isMFAEnabled',
        'googleId',
        'githubId',
        'diamonds',
        'score',
        'createdAt',
        'updatedAt',
      ],
    });

    // If no users exist, return some mock data for testing
    if (users.length === 0) {
      const now = new Date();
      return [
        {
          id: '1',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          password: 'hashed',
          imageUrl: null,
          isEmailVerified: true,
          isMFAEnabled: false,
          googleId: null,
          githubId: null,
          diamonds: 0,
          score: 100,
          createdAt: now,
          updatedAt: now,
        },
        {
          id: '2',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          password: 'hashed',
          imageUrl: null,
          isEmailVerified: true,
          isMFAEnabled: false,
          googleId: null,
          githubId: null,
          diamonds: 0,
          score: 80,
          createdAt: now,
          updatedAt: now,
        },
        {
          id: '3',
          firstName: 'Jane',
          lastName: 'Smith',
          email: 'jane@example.com',
          password: 'hashed',
          imageUrl: null,
          isEmailVerified: true,
          isMFAEnabled: false,
          googleId: null,
          githubId: null,
          diamonds: 0,
          score: 60,
          createdAt: now,
          updatedAt: now,
        },
      ];
    }

    return users;
  }
}
