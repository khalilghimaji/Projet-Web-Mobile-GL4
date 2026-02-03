import { Injectable } from '@angular/core';
import { httpResource } from '@angular/common/http';
import { StandingsResponse } from '../../teams/models/models';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class StandingsService {
  private readonly API_BASE_URL = environment.allSportsApi.baseUrl;

  getStandingsResource(leagueId: () => string) {
    return httpResource<StandingsResponse>(() => {
      const id = leagueId();

      return {
        url: this.API_BASE_URL,
        params: { met: 'Standings', leagueId: id }
      };
    });
  }
}
