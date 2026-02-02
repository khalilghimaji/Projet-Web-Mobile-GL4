import {
  Controller,
  Post,
  Param,
  Body,
  Get,
  Patch,
  UseGuards,
} from '@nestjs/common';
import { MatchesService } from './matches.service';
import { User } from '../Decorator/user.decorator';
import { PredictDto } from './dto/predict.dto';
import { CanPredictMatchDto } from './dto/can-predict-match.dto';
import { UpdatePredictionDto } from './dto/update-prediction.dto';
import { Prediction } from './entities/prediction.entity';
import { MatchStat } from './dto/get-match-stats-info.dto';
import { TerminateMatchDto } from './dto/terminate-match.dto';
import { RedisCacheService } from 'src/Common/cache/redis-cache.service';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { AuthService } from 'src/auth/auth.service';

@Controller('matches')
@UseGuards(JwtAuthGuard)
export class MatchesController {
  constructor(
    private readonly matchesService: MatchesService,
    private readonly cacheService: RedisCacheService,
    private readonly authService: AuthService,
  ) {}

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

  @Get('match-stats-info/:id')
  async getPredictionsStatsForMatch(
    @Param('id') matchId: string,
  ): Promise<MatchStat> {
    return this.matchesService.getPredictionsStatsForMatch(matchId);
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
    console.log('Making prediction for user:', user.id, 'on match:', id, body);
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

  @Get('user/gains')
  async getUserGains(@User('id') userId: string): Promise<number> {
    return (
      (await this.cacheService.getUserGains(userId)) ??
      (await this.authService.getGainsFromDb(userId)) ??
      0
    );
  }
}
