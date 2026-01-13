import {
  Injectable,
  OnModuleInit,
  OnModuleDestroy,
  Logger,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as WebSocket from 'ws';
import { MatchesService } from './matches.service';

interface ScoreUpdateEvent {
  type: 'SCORE_UPDATE';
  match_id: string;
  home_team: string;
  away_team: string;
  score: string; // Format: "2 - 1"
  status: string;
  league_id: string;
  timestamp: string;
}

interface MatchEndedEvent {
  type: 'MATCH_ENDED';
  match_id: string;
  home_team: string;
  home_team_key: string;
  away_team: string;
  away_team_key: string;
  final_score: string; // Format: "2 - 1"
  halftime_score: string;
  league: string;
  league_key: string;
  country: string;
  timestamp: string;
}

interface GoalScoredEvent {
  type: 'GOAL_SCORED';
  match_id: string;
  minute: string;
  scorer: string;
  team: string;
  score: string;
  home_team: string;
  away_team: string;
  league_id: string;
  timestamp: string;
}

interface MatchStartedEvent {
  type: 'MATCH_STARTED';
  match_id: string;
  home_team: string;
  away_team: string;
  league: string;
  league_id: string;
  start_time: string;
  timestamp: string;
}

interface CardIssuedEvent {
  type: 'CARD_ISSUED';
  match_id: string;
  minute: string;
  player: string;
  team: string;
  card_type: string;
  home_team: string;
  away_team: string;
  league_id: string;
  timestamp: string;
}

interface SubstitutionEvent {
  type: 'SUBSTITUTION';
  match_id: string;
  minute: string;
  player_in: string;
  player_out: string;
  team: string;
  home_team: string;
  away_team: string;
  league_id: string;
  timestamp: string;
}

type MatchEvent =
  | ScoreUpdateEvent
  | MatchEndedEvent
  | GoalScoredEvent
  | MatchStartedEvent
  | CardIssuedEvent
  | SubstitutionEvent;

@Injectable()
export class WebSocketClientService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(WebSocketClientService.name);
  private ws: WebSocket;
  private reconnectInterval = 5000;
  private reconnectTimer: NodeJS.Timeout;
  private isConnecting = false;

  constructor(
    private readonly matchesService: MatchesService,
    private readonly configService: ConfigService,
  ) {}

  onModuleInit() {
    this.connect();
  }

  onModuleDestroy() {
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
    }
    if (this.ws) {
      this.ws.close();
    }
  }

  private connect() {
    if (this.isConnecting) return;
    this.isConnecting = true;

    const wsUrl =
      this.configService.get<string>('RUST_WS_URL') || 'ws://localhost:8080/ws';

    this.logger.log(`🔌 Connecting to WebSocket server: ${wsUrl}`);
    this.ws = new WebSocket(wsUrl);

    this.ws.on('open', () => {
      this.logger.log('✅ Connected to Rust WebSocket server');
      this.isConnecting = false;
    });

    this.ws.on('message', async (data: WebSocket.Data) => {
      try {
        const event = JSON.parse(data.toString()) as MatchEvent;
        await this.handleEvent(event);
      } catch (error) {
        this.logger.error('❌ Error handling WebSocket message:', error);
      }
    });

    this.ws.on('error', (error) => {
      this.logger.error('❌ WebSocket error:', error.message);
      this.isConnecting = false;
    });

    this.ws.on('close', () => {
      this.logger.warn('🔌 WebSocket connection closed. Reconnecting...');
      this.isConnecting = false;
      this.reconnectTimer = setTimeout(
        () => this.connect(),
        this.reconnectInterval,
      );
    });
  }

  private async handleEvent(event: MatchEvent) {
    this.logger.debug(
      `📨 Received event: ${event.type} for match ${event.match_id}`,
    );

    try {
      switch (event.type) {
        case 'SCORE_UPDATE':
          await this.handleScoreUpdate(event);
          break;
        case 'GOAL_SCORED':
          await this.handleGoalScored(event);
          break;
        case 'MATCH_ENDED':
          await this.handleMatchEnded(event);
          break;
        case 'MATCH_STARTED':
        case 'CARD_ISSUED':
        case 'SUBSTITUTION':
          this.logger.debug(`ℹ️ Ignoring event: ${event.type}`);
          break;
        default:
          this.logger.warn(`⚠️ Unknown event type: ${(event as any).type}`);
      }
    } catch (error) {
      this.logger.error(
        `❌ Error processing event ${event.type} for match ${event.match_id}:`,
        error,
      );
    }
  }

  private async handleScoreUpdate(event: ScoreUpdateEvent) {
    this.logger.log(
      `⚽ Score update for match ${event.match_id}: ${event.score}`,
    );

    // Parse score "2 - 1" to numbers
    const [homeScore, awayScore] = this.parseScore(event.score);

    try {
      await this.matchesService.updateMatch(
        event.match_id,
        homeScore,
        awayScore,
      );
      this.logger.log(
        `✅ Updated match ${event.match_id} with score ${homeScore}-${awayScore}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to update match ${event.match_id}:`,
        error.message,
      );
    }
  }

  private async handleMatchEnded(event: MatchEndedEvent) {
    this.logger.log(`🏁 Match ended ${event.match_id}: ${event.final_score}`);

    // Parse score "2 - 1" to numbers
    const [homeScore, awayScore] = this.parseScore(event.final_score);

    try {
      await this.matchesService.terminateMatch(
        event.match_id,
        homeScore,
        awayScore,
      );
      this.logger.log(
        `✅ Terminated match ${event.match_id} with final score ${homeScore}-${awayScore}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to terminate match ${event.match_id}:`,
        error.message,
      );
    }
  }

  private async handleGoalScored(event: GoalScoredEvent) {
    this.logger.log(
      `⚽ Goal scored in match ${event.match_id} by ${event.scorer} at ${event.minute}'`,
    );

    // Parse the current score and update the match
    const [homeScore, awayScore] = this.parseScore(event.score);

    try {
      await this.matchesService.updateMatch(
        event.match_id,
        homeScore,
        awayScore,
      );
      this.logger.log(
        `✅ Updated match ${event.match_id} after goal - score: ${homeScore}-${awayScore}`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to update match after goal ${event.match_id}:`,
        error.message,
      );
    }
  }

  private parseScore(scoreString: string): [number, number] {
    // Score format: "2 - 1" or "0 - 0"
    const parts = scoreString.split('-').map((s) => s.trim());
    const homeScore = parseInt(parts[0], 10) || 0;
    const awayScore = parseInt(parts[1], 10) || 0;
    return [homeScore, awayScore];
  }
}
