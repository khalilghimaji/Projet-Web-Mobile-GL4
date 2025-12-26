/**
 * Prediction and voting types
 */

export type VoteOption = 'HOME' | 'DRAW' | 'AWAY';

export interface PredictionData {
  totalVotes: number;
  homePercentage: number;
  drawPercentage: number;
  awayPercentage: number;
  userVote?: VoteOption;
}

export interface Vote {
  userId: string;
  matchId: string;
  option: VoteOption;
  timestamp: Date;
}

export interface PredictionAnalytics {
  predictions: PredictionData;
  oddsHome?: number;
  oddsDraw?: number;
  oddsAway?: number;
  aiPrediction?: VoteOption;
  confidence?: number; // 0-100
}
