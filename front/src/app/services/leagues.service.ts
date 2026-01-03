import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';
import { League, LeaguesResponse } from '../models/models';
import { environment } from '../../environments/environment';

@Injectable({
    providedIn: 'root'
})
export class LeaguesService {
    private readonly API_BASE_URL = environment.allSportsApi.baseUrl;
    private readonly API_KEY = environment.allSportsApi.apiKey;

    // Famous/Popular leagues to display
    private readonly FEATURED_LEAGUE_IDS = [
        '152', // Premier League
        '302', // La Liga
        '207', // Serie A
        '175', // Bundesliga
        '168', // Ligue 1
        '266', // Champions League
        '480', // Europa League
        '101', // FIFA World Cup
    ];

    http = inject(HttpClient);

    constructor() { }

    /**
     * Fetch all leagues from API
     */
    getAllLeagues(): Observable<League[]> {
        const url = `${this.API_BASE_URL}/?met=Leagues&APIkey=${this.API_KEY}`;
        return this.http.get<LeaguesResponse>(url).pipe(
            map(response => {
                console.log('API Response:', response);
                return response.result || [];
            }),
            catchError(error => {
                console.error('Error fetching leagues:', error);
                return of([]);
            })
        );
    }

    /**
     * Get only featured/popular leagues
     */
    getFeaturedLeagues(): Observable<League[]> {
        return this.getAllLeagues().pipe(
            map(leagues => {
                console.log('Total leagues fetched:', leagues.length);
                const filtered = leagues
                console.log('Filtered leagues:', filtered.length, filtered);
                return filtered.sort((a, b) => {
                    // Sort by the order in FEATURED_LEAGUE_IDS
                    const indexA = this.FEATURED_LEAGUE_IDS.indexOf(a.league_key);
                    const indexB = this.FEATURED_LEAGUE_IDS.indexOf(b.league_key);
                    return indexA - indexB;
                });
            })
        );
    }

    /**
     * Search leagues by name or country
     */
    searchLeagues(query: string): Observable<League[]> {
        return this.getAllLeagues().pipe(
            map(leagues =>
                leagues.filter(league =>
                    league.league_name.toLowerCase().includes(query.toLowerCase()) ||
                    league.country_name.toLowerCase().includes(query.toLowerCase())
                )
            )
        );
    }
}
