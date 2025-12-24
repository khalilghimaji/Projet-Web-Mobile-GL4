import { GraphQLModule } from '@nestjs/graphql';
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { config } from 'dotenv';
import { GlobalModule } from './Common/global.module';
import { AuthModule } from './auth/auth.module';
import { User } from './auth/entities/user.entity';
import { ConfigModule, ConfigService } from '@nestjs/config'; // Ajout de ConfigService

import { join } from 'path';
import { NotificationsModule } from './notifications/notifications.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServeStaticModule } from '@nestjs/serve-static';
import { JwtService } from '@nestjs/jwt';
import { JwtModule } from '@nestjs/jwt';
import { ScheduleModule } from '@nestjs/schedule';
import { MatchesModule } from './matches/matches.module';

config({ path: `${process.cwd()}/Config/.env.dev` });

@Module({
  imports: [
    ConfigModule.forRoot({
      // Configuration de ConfigModule
      isGlobal: true,
      envFilePath: [
        `${process.cwd()}/Config/.env`,
        `${process.cwd()}/Config/.env.${process.env.NODE_ENV}`,
      ],
    }),
    ScheduleModule.forRoot(),
    TypeOrmModule.forRootAsync({
      // Configuration de TypeOrmModule
      inject: [ConfigService],
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => {
        return {
          type: 'mysql',
          host: configService.get('DB_HOST'),
          port: configService.get<number>('DB_PORT'),
          username: configService.get<string>('DB_USER'),
          password: configService.get<string>('DB_PASS'),
          database: configService.get<string>('DB_NAME'),
          autoLoadEntities: true,
          synchronize: configService.get<string>('NODE_ENV') === 'dev',
          logging: true,
        };
      },
    }),
    TypeOrmModule.forFeature([User]),
    JwtModule.register({
      secret: process.env.JWT_SECRET, // Make sure this matches your auth configuration
      signOptions: { expiresIn: '1d' }, // Adjust as needed
    }),
    GlobalModule,
    AuthModule,
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'public', 'uploads'),
      serveRoot: '/public/uploads',
    }),
    NotificationsModule,
    MatchesModule,
  ],
  controllers: [AppController],
  providers: [AppService, JwtService],
})
export class AppModule {}
