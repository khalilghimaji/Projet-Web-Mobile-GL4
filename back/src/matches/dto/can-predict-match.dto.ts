import { IsNumber, Min } from 'class-validator';

export class CanPredictMatchDto {
  @Min(1, {
    message: 'You must bet at least 1 diamond.',
  })
  @IsNumber()
  numberOfDiamondsBet: number;
}
