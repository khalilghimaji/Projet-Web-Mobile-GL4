import {
  Controller,
  Post,
  Param,
  Body,
  UseGuards,
  Get,
  Patch,
} from '@nestjs/common';
import { MatchesService } from './matches.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../Decorator/user.decorator';
import { PredictDto } from './dto/predict.dto';
import { CanPredictMatchDto } from './dto/can-predict-match.dto';
import { UpdatePredictionDto } from './dto/update-prediction.dto';
import { Prediction } from './entities/prediction.entity';

@Controller('matches')
@UseGuards(JwtAuthGuard)
export class MatchesController {
  constructor(private readonly matchesService: MatchesService) {}

  @Post('can-predict/:id')
  async canPredict(
    @User('id') userId: string,
    @Param('id') matchId: string,
    @Body()
    boy: CanPredictMatchDto,
  ): Promise<boolean> {
    return this.matchesService.canPredict(
      userId,
      matchId,
      boy.numberOfDiamondsBet,
    );
  }

  @Get(':id/prediction')
  async getUserPrediction(
    @User('id') userId: string,
    @Param('id') matchId: string,
  ): Promise<Prediction | null> {
    return this.matchesService.getUserPrediction(userId, matchId);
  }

  @Post('add-diamond')
  async addDiamond(
    @User('id') userId: string,
    @Body()
    boy: CanPredictMatchDto,
  ): Promise<void> {
    return this.matchesService.addDiamond(userId, boy.numberOfDiamondsBet);
  }

  @Post(':id/predict')
  async makePrediction(
    @User() user: any,
    @Param('id') id: string,
    @Body() body: PredictDto,
  ): Promise<Prediction> {
    return this.matchesService.makePrediction(
      user.id,
      id,
      body.scoreFirst,
      body.scoreSecond,
      body.numberOfDiamondsBet,
    );
  }

  @Patch(':id/prediction')
  async updatePrediction(
    @User('id') userId: string,
    @Param('id') matchId: string,
    @Body() body: UpdatePredictionDto,
  ): Promise<Prediction> {
    return this.matchesService.updatePrediction(
      userId,
      matchId,
      body.scoreFirst,
      body.scoreSecond,
      body.numberOfDiamondsBet,
    );
  }
}
