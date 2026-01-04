import { inject, Injectable } from '@angular/core';
import { HttpClient, httpResource } from '@angular/common/http';
import { League, LeaguesResponse } from '../models/models';
import { environment } from '../../environments/environment';

@Injectable({
    providedIn: 'root'
})
export class LeaguesService {
    private readonly API_BASE_URL = environment.allSportsApi.baseUrl;


    http = inject(HttpClient);

    constructor() { }

    /**
     * Fetch all leagues from API
     */
    leaguesResource = httpResource<League[]>(() => ({
        url: this.API_BASE_URL,
        params: { met: 'Leagues' }
    }), {
        defaultValue: [],

        parse: (response: unknown) => {
            const data = response as LeaguesResponse;
            return data.result || []
        }
    });

}
