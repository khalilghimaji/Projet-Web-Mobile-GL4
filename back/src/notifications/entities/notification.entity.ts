import { Entity, Column } from 'typeorm';
import { NotificationType } from '../../Enums/notification-type.enum';
import { CommonEntity } from 'src/Common/Common.entity';
import { UserRanking } from '../notifications.service';
import { ApiProperty } from '@nestjs/swagger';

export class DataMessage {
  @ApiProperty({ description: 'Gain amount', required: false })
  gain?: number;

  @ApiProperty({ description: 'New diamonds count', required: false })
  newDiamonds?: number;
}

export class UserRankingMessage {
  @ApiProperty({
    description: 'User rankings',
    type: 'array',
    items: {
      type: 'object',
      properties: {
        firstName: { type: 'string' },
        lastName: { type: 'string' },
        score: { type: 'number' },
        imageUrl: { type: 'string' },
      },
    },
  })
  rankings: UserRanking[];
}

@Entity()
export class Notification extends CommonEntity {
  @Column()
  userId: string;

  @Column({
    type: 'enum',
    enum: NotificationType,
  })
  type: NotificationType;

  @Column()
  message: string;

  @Column({ type: 'json', nullable: true })
  @ApiProperty({
    description: 'Additional data for the notification',
    nullable: true,
    anyOf: [
      {
        type: 'object',
        properties: {
          gain: { type: 'number' },
          newDiamonds: { type: 'number' },
        },
      },
      {
        type: 'object',
        properties: {
          rankings: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                firstName: { type: 'string' },
                lastName: { type: 'string' },
                score: { type: 'number' },
                imageUrl: { type: 'string' },
              },
            },
          },
        },
      },
    ],
  })
  data?: DataMessage | UserRankingMessage;

  @Column({ default: false })
  read: boolean;
}
