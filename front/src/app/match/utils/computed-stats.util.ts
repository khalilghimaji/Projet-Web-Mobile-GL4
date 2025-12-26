/**
 * Utility functions for creating computed signals from match data
 */

import { Signal, computed } from '@angular/core';
import { Score } from '../types/match.types';
import { MatchEvent } from '../types/timeline.types';
import { TeamStats, StatItem } from '../types/stats.types';

/**
 * Compute total goals from score
 */
export function computeTotalGoals(scoreSignal: Signal<Score>): Signal<number> {
  return computed(() => {
    const score = scoreSignal();
    return score.home + score.away;
  });
}

/**
 * Compute goal difference
 */
export function computeGoalDifference(scoreSignal: Signal<Score>): Signal<number> {
  return computed(() => {
    const score = scoreSignal();
    return Math.abs(score.home - score.away);
  });
}

/**
 * Compute if match is close (goal difference <= 1)
 */
export function computeIsCloseMatch(scoreSignal: Signal<Score>): Signal<boolean> {
  return computed(() => {
    const score = scoreSignal();
    return Math.abs(score.home - score.away) <= 1;
  });
}

/**
 * Compute number of goals by team from events
 */
export function computeGoalsByTeam(
  eventsSignal: Signal<MatchEvent[]>,
  team: 'home' | 'away'
): Signal<number> {
  return computed(() => {
    const events = eventsSignal();
    return events.filter(e => e.type === 'GOAL' && e.team === team).length;
  });
}

/**
 * Compute number of cards by team
 */
export function computeCardsByTeam(
  eventsSignal: Signal<MatchEvent[]>,
  team: 'home' | 'away'
): Signal<number> {
  return computed(() => {
    const events = eventsSignal();
    return events.filter(
      e => (e.type === 'YELLOW_CARD' || e.type === 'RED_CARD') && e.team === team
    ).length;
  });
}

/**
 * Compute possession dominance (returns 'home', 'away', or 'balanced')
 */
export function computePossessionDominance(
  statsSignal: Signal<TeamStats>
): Signal<'home' | 'away' | 'balanced'> {
  return computed(() => {
    const stats = statsSignal();
    const possessionStat = stats.stats.find(s => s.label.toLowerCase() === 'possession');

    if (!possessionStat) return 'balanced';

    const difference = Math.abs(possessionStat.homeValue - possessionStat.awayValue);

    if (difference < 10) return 'balanced';

    return possessionStat.homeValue > possessionStat.awayValue ? 'home' : 'away';
  });
}

/**
 * Compute shot efficiency (shots on target / total shots)
 */
export function computeShotEfficiency(
  statsSignal: Signal<TeamStats>,
  team: 'home' | 'away'
): Signal<number> {
  return computed(() => {
    const stats = statsSignal();
    const shots = stats.stats.find(s => s.label.toLowerCase() === 'shots');
    const shotsOnTarget = stats.stats.find(s => s.label.toLowerCase() === 'shots on target');

    if (!shots || !shotsOnTarget) return 0;

    const totalShots = team === 'home' ? shots.homeValue : shots.awayValue;
    const onTarget = team === 'home' ? shotsOnTarget.homeValue : shotsOnTarget.awayValue;

    if (totalShots === 0) return 0;

    return Math.round((onTarget / totalShots) * 100);
  });
}

/**
 * Compute specific stat value by label
 */
export function computeStatValue(
  statsSignal: Signal<TeamStats>,
  label: string,
  team: 'home' | 'away'
): Signal<number> {
  return computed(() => {
    const stats = statsSignal();
    const stat = stats.stats.find(s => s.label.toLowerCase() === label.toLowerCase());

    if (!stat) return 0;

    return team === 'home' ? stat.homeValue : stat.awayValue;
  });
}

/**
 * Compute latest events (last N events)
 */
export function computeLatestEvents(
  eventsSignal: Signal<MatchEvent[]>,
  count: number = 5
): Signal<MatchEvent[]> {
  return computed(() => {
    const events = eventsSignal();
    return events.slice(-count).reverse();
  });
}

/**
 * Compute events by type
 */
export function computeEventsByType(
  eventsSignal: Signal<MatchEvent[]>,
  type: 'GOAL' | 'YELLOW_CARD' | 'RED_CARD' | 'SUBSTITUTION'
): Signal<MatchEvent[]> {
  return computed(() => {
    const events = eventsSignal();
    return events.filter(e => e.type === type);
  });
}
