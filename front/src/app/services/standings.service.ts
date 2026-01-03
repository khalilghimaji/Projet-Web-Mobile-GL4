import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { StandingsResponse } from '../models/models';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class StandingsService {
  private readonly API_BASE_URL = environment.allSportsApi.baseUrl;
  private readonly API_KEY = environment.allSportsApi.apiKey;

  // Cache for standings data
  private standingsCache = new Map<string, BehaviorSubject<StandingsResponse | null>>();

  http = inject(HttpClient);
  constructor() { }

  /**
   * Fetch standings for a specific league
   * @param leagueId - The league ID to fetch standings for
   * @returns Observable of StandingsResponse
   */
  getStandings(leagueId: string): Observable<StandingsResponse> {
    const params = new HttpParams().append('met', 'Standings').append('leagueId', leagueId).append('APIkey', this.API_KEY);
    return this.http.get<StandingsResponse>(this.API_BASE_URL, { params }).pipe(
      tap(response => {
        // Update cache
        this.updateCache(leagueId, response);
      }),
      catchError(error => {
        console.error('Error fetching standings:', error);
        throw error;
      })
    );
  }

  /**
   * Get cached standings for a league
   * @param leagueId - The league ID
   * @returns BehaviorSubject of cached standings
   */
  getCachedStandings(leagueId: string): Observable<StandingsResponse | null> {
    if (!this.standingsCache.has(leagueId)) {
      this.standingsCache.set(leagueId, new BehaviorSubject<StandingsResponse | null>(null));
      // Fetch initial data
      this.getStandings(leagueId).subscribe();
    }
    return this.standingsCache.get(leagueId)!.asObservable();
  }

  /**
   * Refresh standings for a specific league
   * @param leagueId - The league ID to refresh
   */
  refreshStandings(leagueId: string): void {
    this.getStandings(leagueId).subscribe();
  }

  /**
   * Update cache with new standings data
   */
  private updateCache(leagueId: string, data: StandingsResponse): void {
    if (!this.standingsCache.has(leagueId)) {
      this.standingsCache.set(leagueId, new BehaviorSubject<StandingsResponse | null>(data));
    } else {
      this.standingsCache.get(leagueId)!.next(data);
    }
  }

  /**
   * Clear cache for a specific league or all leagues
   */
  clearCache(leagueId?: string): void {
    if (leagueId) {
      this.standingsCache.delete(leagueId);
    } else {
      this.standingsCache.clear();
    }
  }
}