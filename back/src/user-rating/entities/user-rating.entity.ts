import { User } from 'src/auth/entities/user.entity';
import { CommonEntity } from 'src/Common/Common.entity';
import { Entity, ManyToOne, JoinColumn, Column } from 'typeorm';

@Entity()
export class UserRating extends CommonEntity {
  @ManyToOne(() => User, (user) => user.ratings, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user: User;

  @Column('float')
  rate: number;
}
