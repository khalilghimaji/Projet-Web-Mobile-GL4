import { IsNumber, IsOptional } from 'class-validator';

export class UpdatePredictionDto {
  @IsOptional()
  @IsNumber()
  scoreFirst?: number;

  @IsOptional()
  @IsNumber()
  scoreSecond?: number;

  @IsOptional()
  @IsNumber()
  numberOfDiamondsBet?: number;
}
