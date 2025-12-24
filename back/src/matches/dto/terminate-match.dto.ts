import { IsNumber } from 'class-validator';

export class TerminateMatchDto {
  @IsNumber()
  scoreFirst: number;

  @IsNumber()
  scoreSecond: number;
}
