import { CommonEntity } from '../../Common/Common.entity';
import { Column, Entity, ManyToOne, JoinColumn } from 'typeorm';
import { User } from '../../auth/entities/user.entity';
import { Match } from './match.entity';

@Entity('prediction')
export class Prediction extends CommonEntity {
  @ManyToOne(() => User, (user) => user.id)
  @JoinColumn({ name: 'userId' })
  user: User;

  @Column()
  userId: string;

  @ManyToOne(() => Match, (match) => match.predictions)
  @JoinColumn({ name: 'matchId' })
  match: Match;

  @Column()
  matchId: string;

  @Column()
  scoreFirstEquipe: number;

  @Column()
  scoreSecondEquipe: number;

  @Column()
  numberOfDiamondsBet: number;

  @Column()
  pointsEarned: number;
}
