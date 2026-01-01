import { Entity, Column } from 'typeorm';
import { NotificationType } from '../../Enums/notification-type.enum';
import { CommonEntity } from 'src/Common/Common.entity';
import { UserRankingMessage } from '../notifications.service';

class DataMessage {
  gain?: number;
  newDiamonds?: number;
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
  data?: DataMessage | UserRankingMessage;

  @Column({ default: false })
  read: boolean;
}
