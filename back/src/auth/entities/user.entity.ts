import { CommonEntity } from '../../Common/Common.entity';
import { Column, Entity, OneToMany } from 'typeorm';
import { Notification } from 'src/notifications/entities/notification.entity';
import { Prediction } from 'src/matches/entities/prediction.entity';

@Entity('_user')
export class User extends CommonEntity {
  @Column()
  firstName: string;

  @Column()
  lastName: string;

  @Column({ unique: true })
  email: string;

  @Column({ nullable: true })
  password: string;

  @Column({ nullable: true })
  imageUrl: string;

  @Column({ default: false })
  isEmailVerified: boolean;

  @Column({ nullable: true, type: 'varchar' })
  verificationToken: string | null;

  @Column({ default: false })
  isMFAEnabled: boolean;

  @Column({ nullable: true, type: 'varchar' })
  mfaSecret: string | null;

  @Column('simple-array', { nullable: true })
  recoveryCodes: string[] | null;

  @Column({ nullable: true })
  googleId: string;

  @Column({ nullable: true })
  githubId: string;

  @Column({ default: 0 })
  diamonds: number;

  @Column({ default: 0 })
  score: number;

  @Column({ nullable: true, type: 'text' })
  refreshToken?: string;

  @OneToMany(() => Prediction, (prediction) => prediction.user)
  predictions: Prediction[];

  // Relation inverse : un utilisateur peut recevoir plusieurs notifications
  @OneToMany(() => Notification, (notification) => notification.userId, {
    cascade: true,
  })
  notifications: Notification[];
}
