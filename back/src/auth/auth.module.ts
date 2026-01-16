import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MailService } from '../Common/Emailing/mail.service';
import { JwtStrategy } from './strategies/jwt.strategy';
import { GoogleStrategy } from './strategies/google.strategy';
import { GithubStrategy } from './strategies/github.strategy';
import { UserController } from './user.controller';

// Helper function to parse JWT expiry strings to seconds
function parseExpiryToSeconds(expiry: string): number {
  const match = expiry.match(/^(\d+)([smhdy])$/);
  if (!match) return 3600; // Default 1 hour

  const value = parseInt(match[1]);
  const unit = match[2];

  switch (unit) {
    case 's':
      return value;
    case 'm':
      return value * 60;
    case 'h':
      return value * 60 * 60;
    case 'd':
      return value * 24 * 60 * 60;
    case 'y':
      return value * 365 * 24 * 60 * 60;
    default:
      return 3600;
  }
}

@Module({
  imports: [
    TypeOrmModule.forFeature([User]),
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        const expiresIn = configService.get<string>('EXPIRES_IN') || '1h';
        return {
          secret: configService.get<string>('SECRET_KEY') || 'default-secret',
          signOptions: {
            expiresIn: parseExpiryToSeconds(expiresIn),
          },
        };
      },
    }),
  ],
  controllers: [AuthController, UserController],
  providers: [
    AuthService,
    JwtStrategy,
    GoogleStrategy,
    GithubStrategy,
    MailService,
  ],
  exports: [JwtStrategy, PassportModule, AuthService],
})
export class AuthModule {}
