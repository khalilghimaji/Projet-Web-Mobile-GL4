/**
 * Match statistics types
 */

export interface StatItem {
  label: string;
  homeValue: number;
  awayValue: number;
  isPercentage?: boolean;
}

export interface TeamStats {
  stats: StatItem[];
}

export interface DetailedStats {
  possession: StatItem;
  shots: StatItem;
  shotsOnTarget: StatItem;
  corners: StatItem;
  fouls: StatItem;
  offsides: StatItem;
  saves: StatItem;
  passAccuracy: StatItem;
  tackles: StatItem;
  aerialDuels: StatItem;
}

export type StatCategory =
  | 'possession'
  | 'shots'
  | 'shotsOnTarget'
  | 'corners'
  | 'fouls'
  | 'offsides'
  | 'saves'
  | 'passAccuracy'
  | 'tackles'
  | 'aerialDuels';
