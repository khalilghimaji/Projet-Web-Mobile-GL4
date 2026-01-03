/**
 * Utility functions for calculating player positions based on formation
 */

import { Formation, Position, PlayerPosition } from '../types/lineup.types';

/**
 * Parse formation string into array of line counts
 * Example: "4-3-3" => [4, 3, 3]
 */
export function parseFormation(formation: Formation): number[] {
  return formation.split('-').map(n => parseInt(n, 10));
}

/**
 * Calculate player positions for a given formation
 * Returns array of positions for players (excluding goalkeeper)
 */
export function calculateFormationPositions(
  formation: Formation,
  team: 'home' | 'away'
): Position[] {
  const lines = parseFormation(formation);
  const positions: Position[] = [];

  // Starting Y position (defenders start closer to goal)
  const baseY = team === 'home' ? 20 : 80;
  const yDirection = team === 'home' ? 1 : -1;
  const ySpacing = 13; // Vertical spacing between lines

  lines.forEach((playerCount, lineIndex) => {
    const y = baseY + (yDirection * ySpacing * lineIndex);
    const xPositions = calculateXPositions(playerCount);

    xPositions.forEach(x => {
      positions.push({
        x: `${x}%`,
        y: `${y}%`
      });
    });
  });

  return positions;
}

/**
 * Calculate horizontal positions for players in a line
 */
function calculateXPositions(playerCount: number): number[] {
  if (playerCount === 1) return [50]; // Center

  const positions: number[] = [];
  const spacing = 70 / (playerCount + 1); // 70% of width, evenly spaced
  const offset = 15; // Start from 15% from left

  for (let i = 1; i <= playerCount; i++) {
    positions.push(offset + (spacing * i));
  }

  return positions;
}

/**
 * Get goalkeeper position
 */
export function getGoalkeeperPosition(team: 'home' | 'away'): Position {
  return {
    x: '50%',
    y: team === 'home' ? '8%' : '92%'
  };
}

/**
 * Map formation positions to players
 */
export function mapPlayersToFormation(
  players: Omit<PlayerPosition, 'position'>[],
  formation: Formation,
  team: 'home' | 'away'
): PlayerPosition[] {
  const positions = calculateFormationPositions(formation, team);

  // Separate goalkeeper and outfield players
  const goalkeeper = players.find(p => p.isGoalkeeper);
  const outfieldPlayers = players.filter(p => !p.isGoalkeeper);

  const result: PlayerPosition[] = [];

  // Add goalkeeper
  if (goalkeeper) {
    result.push({
      ...goalkeeper,
      position: getGoalkeeperPosition(team)
    });
  }

  // Map outfield players to positions
  outfieldPlayers.forEach((player, index) => {
    if (index < positions.length) {
      result.push({
        ...player,
        position: positions[index]
      });
    }
  });

  return result;
}

/**
 * Validate formation string
 */
export function isValidFormation(formation: string): boolean {
  const pattern = /^\d(-\d)+$/;
  if (!pattern.test(formation)) return false;

  const numbers = parseFormation(formation);
  const total = numbers.reduce((sum, n) => sum + n, 0);

  // Should have 10 outfield players (excluding goalkeeper)
  return total === 10;
}

/**
 * Get common formations
 */
export const COMMON_FORMATIONS: Formation[] = [
  '4-3-3',
  '4-4-2',
  '4-2-3-1',
  '3-5-2',
  '3-4-3',
  '5-3-2',
  '4-1-4-1',
  '4-5-1'
];

/**
 * Get formation description
 */
export function getFormationDescription(formation: Formation): string {
  const descriptions: Record<string, string> = {
    '4-3-3': 'Attacking formation with wingers',
    '4-4-2': 'Classic balanced formation',
    '4-2-3-1': 'Defensive midfield with attacking three',
    '3-5-2': 'Wing-backs providing width',
    '3-4-3': 'Attacking with three center-backs',
    '5-3-2': 'Defensive formation with wing-backs',
    '4-1-4-1': 'Holding midfielder anchoring',
    '4-5-1': 'Defensive with lone striker'
  };

  return descriptions[formation] || 'Custom formation';
}
