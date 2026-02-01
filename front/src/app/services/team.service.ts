import {
  Injectable,
  Signal,
  inject,
  computed,
  signal,
  Injector,
} from '@angular/core';
import { HttpClient, httpResource } from '@angular/common/http';

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
  private injector = inject(Injector);

  private transformTeamResponse(response: ApiResponse<Team>): Team | null {
    if (
      response.success === 1 &&
      response.result &&
      response.result.length > 0
    ) {
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

  private transformNextMatchResponse(
    response: ApiResponse<Fixture>
  ): Fixture | null {
    if (
      response.success === 1 &&
      response.result &&
      response.result.length > 0
    ) {
      const upcoming = response.result.find(
        (f) => f.event_status === '' || f.event_status === 'Not Started'
      );
      return upcoming || response.result[0];
    }
    return null;
  }

  private transformStandingsResponse(
    response: ApiResponse<Standing>
  ): Standing[] {
    if (response.success === 1 && response.result) {
      return response.result;
    }
    return [];
  }

  getTeamResource(teamId: Signal<number>) {
  return httpResource(
    () => ({
      url: this.apiUrl,
      params: {met : 'Teams' , teamId : teamId().toString(), APIkey : this.apiKey},
    }),
    {
      parse: (response: any) => this.transformTeamResponse(response),
    }
  );
}

  getRecentMatchesResource(
    teamId: Signal<number>,
    fromDaysAgo: Signal<number>,
    toDaysAgo: Signal<number>
  ) {
    return httpResource<Fixture[]>(
      () => {
        const id = teamId();
        const fromVal = fromDaysAgo();
        const toVal = toDaysAgo();

        const today = new Date();
        const fromDate = new Date();
        fromDate.setDate(today.getDate() - fromVal);

        const toDate = new Date();
        toDate.setDate(today.getDate() - toVal);

        const from = this.formatDate(fromDate);
        const to = this.formatDate(toDate);

        return {
          url: this.apiUrl,
          params: {met : 'Fixtures' , teamId : id.toString(), from : from, to : to},
        };
      },
      {
        parse: (response: any) => this.transformFixturesResponse(response),
        
      }
    );
  }

  /**
   * Get next match using resource
   */
  getNextMatchResource(teamId: Signal<number>) {
    return httpResource(
      () => {
        const today = new Date();
        const futureDate = new Date();
        futureDate.setDate(today.getDate() + 30);

        const from = this.formatDate(today);
        const to = this.formatDate(futureDate);

        return {
          url:
            this.apiUrl
          ,
          params: {met : 'Fixtures' , teamId : teamId().toString(), from : from, to : to}
        };
      },
      {
        parse: (response: any) => this.transformNextMatchResponse(response),
      }
    );
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
