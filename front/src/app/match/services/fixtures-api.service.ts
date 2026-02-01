import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';
import { Fixture, League } from '../types/fixture.types';
import {environment} from '../../../environments/environment';

interface AllSportsApiResponse<T> {
  success: number;
  result: T;
}

@Injectable({ providedIn: 'root' })
export class FixturesApiService {
  private http = inject(HttpClient);

  private readonly API_BASE_URL = environment.allSportsApi.baseUrl;
  private readonly API_KEY = environment.allSportsApi.apiKey;

  private readonly FEATURED_LEAGUE_IDS = [
    '152',
    '302',
    '207',
    '175',
    '168',
  ];

  getFixtures(from: string, to: string, leagueId?: string): Observable<Fixture[]> {
    let url = `${this.API_BASE_URL}/?met=Fixtures&APIkey=${this.API_KEY}&from=${from}&to=${to}`;

    if (leagueId && leagueId !== 'all') {
      url += `&leagueId=${leagueId}`;
    }

    return this.http.get<AllSportsApiResponse<Fixture[]>>(url).pipe(
      map(response => {
        console.log('Fixtures API Response:', response);
        return response.result || [];
      }),
      catchError(error => {
        console.error('Error fetching fixtures:', error);
        return of([]);
      })
    );
  }

  getLiveMatches(): Observable<Fixture[]> {
    const url = `${this.API_BASE_URL}/?met=Livescore&APIkey=${this.API_KEY}`;

    return this.http.get<AllSportsApiResponse<Fixture[]>>(url).pipe(
      map(response => {
        console.log('Livescore API Response:', response);
        return response.result || [];
      }),
      catchError(error => {
        console.error('Error fetching live matches:', error);
        return of([]);
      })
    );
  }

  getAllLeagues(): Observable<League[]> {
    const url = `${this.API_BASE_URL}/?met=Leagues&APIkey=${this.API_KEY}`;

    return this.http.get<AllSportsApiResponse<League[]>>(url).pipe(
      map(response => {
        console.log('Leagues API Response:', response);
        return response.result || [];
      }),
      catchError(error => {
        console.error('Error fetching leagues:', error);
        return of([]);
      })
    );
  }

  getFeaturedLeagues(): Observable<League[]> {
    return this.getAllLeagues().pipe(
      map(leagues => {
        const featured = leagues.filter(league =>
          this.FEATURED_LEAGUE_IDS.includes(league.league_key)
        );

        return featured.sort((a, b) => {
          const indexA = this.FEATURED_LEAGUE_IDS.indexOf(a.league_key);
          const indexB = this.FEATURED_LEAGUE_IDS.indexOf(b.league_key);
          return indexA - indexB;
        });
      })
    );
  }

  getLeaguesByCountry(countryId: string): Observable<League[]> {
    const url = `${this.API_BASE_URL}/?met=Leagues&APIkey=${this.API_KEY}&countryId=${countryId}`;

    return this.http.get<AllSportsApiResponse<League[]>>(url).pipe(
      map(response => response.result || []),
      catchError(error => {
        console.error('Error fetching leagues by country:', error);
        return of([]);
      })
    );
  }
}

