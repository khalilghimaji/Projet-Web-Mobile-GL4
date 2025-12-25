import { Controller, Post, Param, Body, UseGuards, Get } from '@nestjs/common';
import { MatchesService } from './matches.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../Decorator/user.decorator';
import { TerminateMatchDto } from './dto/terminate-match.dto';
import { PredictDto } from './dto/predict.dto';

@Controller('matches')
@UseGuards(JwtAuthGuard)
export class MatchesController {
  constructor(private readonly matchesService: MatchesService) {}

  @Post(':id/activate')
  async activateMatch(@Param('id') id: string) {
    return this.matchesService.activateMatch(id);
  }

  @Post(':id/disable')
  async disableMatch(@Param('id') id: string) {
    return this.matchesService.disableMatch(id);
  }

  @Get('can-predict/:id')
  async canPredict(
    @User('id') userId: string,
    @Param('id') matchId: string,
    @Body()
    boy: {
      numberOfDiamondsBet: number;
    },
  ) {
    return this.matchesService.canPredict(
      userId,
      matchId,
      boy.numberOfDiamondsBet,
    );
  }

  @Post(':id/terminate')
  async terminateMatch(
    @Param('id') id: string,
    @Body() body: TerminateMatchDto,
  ) {
    return this.matchesService.terminateMatch(
      id,
      body.scoreFirst,
      body.scoreSecond,
    );
  }

  @Post(':id/update')
  async updateMatch(@Param('id') id: string, @Body() body: TerminateMatchDto) {
    return this.matchesService.updateMatch(
      id,
      body.scoreFirst,
      body.scoreSecond,
    );
  }

  @Post(':id/predict')
  async makePrediction(
    @User() user: any,
    @Param('id') id: string,
    @Body() body: PredictDto,
  ) {
    return this.matchesService.makePrediction(
      user.id,
      id,
      body.scoreFirst,
      body.scoreSecond,
      body.numberOfDiamondsBet,
    );
  }
}
