/**
 * Lineup and player position types
 */

import { TeamSide } from './timeline.types';

export interface Position {
  x: string; // Percentage or pixel value (e.g., "50%" or "15%")
  y: string;
}

export interface Player {
  id: string;
  number: number;
  name: string;
  fullName?: string;
  photo?: string;
}

export interface PlayerPosition extends Player {
  position: Position;
  team: TeamSide;
  isGoalkeeper?: boolean;
  isCaptain?: boolean;
  isSubstitute?: boolean;
}

export type Formation = '4-3-3' | '4-4-2' | '4-2-3-1' | '3-5-2' | '3-4-3' | '5-3-2' | string;

export interface TeamLineup {
  formation: Formation;
  players: PlayerPosition[];
  substitutes?: Player[];
  coach?: string;
}

export interface Lineups {
  homeFormation: Formation;
  awayFormation: Formation;
  homePlayers: PlayerPosition[];
  awayPlayers: PlayerPosition[];
  homeSubstitutes?: Player[];
  awaySubstitutes?: Player[];
}
