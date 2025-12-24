import { CommonEntity } from '../../Common/Common.entity';
import { Column, Entity, OneToMany } from 'typeorm';
import { MatchStatus } from '../../Enums/matchstatus.enum';
import { Prediction } from './prediction.entity';

@Entity('match')
export class Match extends CommonEntity {
  @Column({
    type: 'enum',
    enum: MatchStatus,
    default: MatchStatus.INACTIVE,
  })
  status: MatchStatus;

  @Column({ nullable: true })
  scoreFirstTeam: number;

  @Column({ nullable: true })
  scoreSecondTeam: number;

  @OneToMany(() => Prediction, (prediction) => prediction.match)
  predictions: Prediction[];
}
