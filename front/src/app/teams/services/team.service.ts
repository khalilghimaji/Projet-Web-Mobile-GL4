import { Injectable, Signal, inject, computed , signal } from '@angular/core';
import { HttpClient, httpResource } from '@angular/common/http';
import { rxResource } from '@angular/core/rxjs-interop';
import { map, Observable } from 'rxjs';
import { environment } from '../../../environments/environment.development';
import { Team, Fixture, Standing, NextMatchData } from '../models/models';

interface ApiResponse<T> {
  success: number;
  result: T[];
}

interface MatchSettings {
  limit: number;
  skip: number;
}

interface PaginatedMatchParams {
  teamId: number;
  settings: MatchSettings;
}


@Injectable({
  providedIn: 'root',
})
export class TeamService {
  private http = inject(HttpClient);
  private apiUrl = environment.allSportsApi.baseUrl;
  private apiKey = environment.allSportsApi.apiKey;




  private transformTeamResponse(response: ApiResponse<Team>): Team | null {
    if (response.success === 1 && response.result && response.result.length > 0) {
      return response.result[0];
    }
    return null;
  }


  private transformFixturesResponse(response: ApiResponse<Fixture>): Fixture[] {
    if (response.success === 1 && response.result) {
      return response.result;
    }
    return [];
  }



  private transformNextMatchResponse(response: ApiResponse<Fixture>): Fixture | null {
    if (response.success === 1 && response.result && response.result.length > 0) {
      const upcoming = response.result.find(f =>
        f.event_status === '' || f.event_status === 'Not Started'
      );
      return upcoming || response.result[0];
    }
    return null;
  }


  private transformStandingsResponse(response: ApiResponse<Standing>): Standing[] {
    if (response.success === 1 && response.result) {
      return response.result;
    }
    return [];
  }


  getTeamResource(teamId: Signal<number>) {

    return rxResource({
      params: teamId,
      stream: (params) => {
        const url = `${this.apiUrl}?met=Teams&teamId=${params.params}`;
        return this.http.get<ApiResponse<Team>>(url).pipe(
          map(response => this.transformTeamResponse(response))
        );
      }
    });
  }



  getRecentMatchesResource(
    teamId: Signal<number>,
    fromDaysAgo: Signal<number>,
    toDaysAgo: Signal<number> = signal(0)
  ) {
    return rxResource({
      params: computed(() => ({
        teamId: teamId(),
        fromDays: fromDaysAgo(),
        toDays: toDaysAgo()
      })),
      stream: ({ params }) => {
        const today = new Date();
        const startDate = new Date();
        const endDate = new Date();

        startDate.setDate(today.getDate() - params.fromDays);
        endDate.setDate(today.getDate() - params.toDays);

        const from = this.formatDate(startDate);
        const to = this.formatDate(endDate);

        return this.http.get<ApiResponse<Fixture>>(
          `${this.apiUrl}?met=Fixtures&teamId=${params.teamId}&from=${from}&to=${to}&APIkey=${this.apiKey}`
        ).pipe(
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

    return rxResource({
      params: teamId,
      stream: (params) => {
        return this.http.get<ApiResponse<Fixture>>(`${this.apiUrl}?met=Fixtures&teamId=${params.params}&from=${from}&to=${to}`).pipe(
          map(response => this.transformNextMatchResponse(response))
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
