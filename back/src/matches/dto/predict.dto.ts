import { IsNumber } from 'class-validator';

export class PredictDto {
  @IsNumber()
  scoreFirst: number;

  @IsNumber()
  scoreSecond: number;
}
