import { Injectable, Signal, inject } from '@angular/core';
import { HttpClient , httpResource } from '@angular/common/http';
import { rxResource } from '@angular/core/rxjs-interop';
import { map } from 'rxjs';
import { environment } from '../../environments/environment.development';
import { Team, Fixture, Standing, NextMatchData } from '../models/models';

interface ApiResponse<T> {
  success: number;
  result: T[];
}

@Injectable({
  providedIn: 'root',
})
export class TeamService {
  private http = inject(HttpClient);
  private apiUrl = environment.allSportsApi.baseUrl;
  private apiKey = environment.allSportsApi.apiKey;

  /**
   * Transform API response body into a Team object
   * Extracts the first team from the result array
   */
  private transformTeamResponse(response: ApiResponse<Team>): Team | null {
    if (response.success === 1 && response.result && response.result.length > 0) {
      return response.result[0];
    }
    return null;
  }

  /**
   * Transform API response body into Fixtures array
   */
  private transformFixturesResponse(response: ApiResponse<Fixture>): Fixture[] {
    if (response.success === 1 && response.result) {
      return response.result;
    }
    return [];
  }

  /**
   * Transform API response body to get next match
   */
  private transformNextMatchResponse(response: ApiResponse<Fixture>): Fixture | null {
    if (response.success === 1 && response.result && response.result.length > 0) {
      const upcoming = response.result.find(f => 
        f.event_status === '' || f.event_status === 'Not Started'
      );
      return upcoming || response.result[0];
    }
    return null;
  }

  /**
   * Transform API response body into Standings array
   */
  private transformStandingsResponse(response: ApiResponse<Standing>): Standing[] {
    if (response.success === 1 && response.result) {
      return response.result;
    }
    return [];
  }

  /**
   * Get team basic info + players using resource
   */
  getTeamResource(teamId: Signal<number>) {

    const url = `${this.apiUrl}/?met=Teams&teamId=${teamId()}&APIkey=${this.apiKey}`;

    return rxResource({
      stream: () => {
        return this.http.get<ApiResponse<Team>>(url).pipe(
          map(response => this.transformTeamResponse(response))
        );
      }
    });
  }


  /**
   * Get recent matches using resource
   */
  getRecentMatchesResource(teamId: Signal<number>, days = 90) {
    const today = new Date();
    const pastDate = new Date();
    pastDate.setDate(today.getDate() - days);
    
    const from = this.formatDate(pastDate);
    const to = this.formatDate(today);
    const url = `${this.apiUrl}/?met=Fixtures&teamId=${teamId()}&from=${from}&to=${to}&APIkey=${this.apiKey}`;

    return rxResource({
      stream: () => {
        return this.http.get<ApiResponse<Fixture>>(url).pipe(
          map(response => this.transformFixturesResponse(response))
        );
      }
    });
  }

  /**
   * Get next match using resource
   */
  getNextMatchResource(teamId: Signal<number>) {
    const today = new Date();
    const futureDate = new Date();
    futureDate.setDate(today.getDate() + 30);
    
    const from = this.formatDate(today);
    const to = this.formatDate(futureDate);
    const url = `${this.apiUrl}/?met=Fixtures&teamId=${teamId()}&from=${from}&to=${to}&APIkey=${this.apiKey}`;

    return rxResource({
      stream: () => {
        return this.http.get<ApiResponse<Fixture>>(url).pipe(
          map(response => this.transformNextMatchResponse(response))
        );
      }
    });
  }

  /**
   * Get standings using resource
   */
  getStandingsResource(leagueId: Signal<number | undefined>) {
    const id = leagueId();
    const url = id ? `${this.apiUrl}/?met=Standings&leagueId=${id}&APIkey=${this.apiKey}` : '';

    return rxResource({
      stream: () => {
        if (!url) {
          return this.http.get<ApiResponse<Standing>>('').pipe(
            map(() => [])
          );
        }
        return this.http.get<ApiResponse<Standing>>(url).pipe(
          map(response => this.transformStandingsResponse(response))
        );
      }
    });
  }

  /**
   * Format date to yyyy-mm-dd
   */
  private formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }
}
