import {HttpClient} from '@angular/common/http';
import {inject, Injectable} from '@angular/core';
import {forkJoin, shareReplay} from 'rxjs';
import {map, switchMap} from 'rxjs/operators';

@Injectable({ providedIn: 'root' })
export class MatchApiService {
  private http = inject(HttpClient);
  private BASE_URL = 'https://apiv2.allsportsapi.com/football/';

  getMatch(matchId: string) {
    // console.log(`api key ${process.env['APIKEY']!}`);
    console.log(`match id ${matchId}`);
    console.log('Making general info, videos, and h2h requests');
    console.log(`Base URL: ${this.BASE_URL}`);
    const generalInfo = this.http.get(this.BASE_URL, {
      params: {
        met: 'Fixtures',
        APIkey: '16436c2c52456379013dd8484ec936bec2cf877192a3b885f697d71086c5f0b7',
        matchId: matchId
      }
    }).pipe(shareReplay(1));

    console.log(`general info request made`);
    const videos = this.http.get(this.BASE_URL, {
      params: {
        met: 'Videos',
        APIkey: '16436c2c52456379013dd8484ec936bec2cf877192a3b885f697d71086c5f0b7',
        eventId: matchId
      }
    });

    const h2h = generalInfo.pipe(
      map((gi: any) => {
        const r = gi?.result?.[0] ?? gi?.result ?? gi;
        const firstTeamId = r.home_team_key
        const secondTeamId = r.away_team_key
        return { firstTeamId, secondTeamId };
      }),
      switchMap(({ firstTeamId, secondTeamId }) =>
        this.http.get(this.BASE_URL, {
          params: {
            met: 'H2H',
            APIkey: '16436c2c52456379013dd8484ec936bec2cf877192a3b885f697d71086c5f0b7',
            firstTeamId: firstTeamId,
            secondTeamId: secondTeamId
          }
        })
      )
    );
    console.log('all requests made, combining results');

    return forkJoin({
      generalInfo,
      highlights: videos,
      h2h
    }).pipe(
      map(({ generalInfo, highlights, h2h }) => ({
        ...((generalInfo as any).result[0]),
        highlights:(highlights as any).success == '1' ? (highlights as any).result ?? [] : [],
        h2h: (h2h as any).success == '1' ? (h2h as any).result ?? [] : []
      }))
    );
  }
}
