import { Controller, Post, Param, Body, UseGuards } from '@nestjs/common';
import { MatchesService } from './matches.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PredictDto } from './dto/predict.dto';
import { CanPredictMatchDto } from './dto/can-predict-match.dto';
import { Prediction } from './entities/prediction.entity';
import { TerminateMatchDto } from './dto/terminate-match.dto';
@Controller('test')
@UseGuards(JwtAuthGuard)
export class TestController {
  constructor(private readonly matchesService: MatchesService) {}

  @Post(':userId/add-diamond')
  async addDiamond(
    @Param('userId') userId: string,
    @Body()
    boy: CanPredictMatchDto,
  ): Promise<void> {
    return this.matchesService.addDiamond(userId, boy.numberOfDiamondsBet);
  }

  @Post(':userId/:matchId/predict')
  async makePrediction(
    @Param('userId') userId: string,
    @Param('matchId') matchId: string,
    @Body() body: PredictDto,
  ): Promise<Prediction> {
    return this.matchesService.makePrediction(
      userId,
      matchId,
      body.scoreFirst,
      body.scoreSecond,
      body.numberOfDiamondsBet,
    );
  }

  @Post(':id/update-match')
  async updateMatch(
    @Param('id') id: string,
    @Body()
    body: TerminateMatchDto,
  ): Promise<void> {
    return this.matchesService.updateMatch(
      id,
      body.scoreFirst,
      body.scoreSecond,
    );
  }

  @Post(':id/end-match')
  async endMatch(
    @Param('id') id: string,
    @Body()
    body: TerminateMatchDto,
  ): Promise<void> {
    return this.matchesService.endMatch(id, body.scoreFirst, body.scoreSecond);
  }
}
