import {HttpClient} from '@angular/common/http';
import {inject, Injectable} from '@angular/core';
import {forkJoin} from 'rxjs';
import {map} from 'rxjs/operators';

@Injectable({ providedIn: 'root' })
export class MatchApiService {
  private http = inject(HttpClient);
  private BASE_URL = 'https://apiv2.allsportsapi.com/football/';

  getMatch(matchId: string) {
    console.log(`match id ${matchId}`);
    console.log(process.env['APIKEY']!);
    const generalInfo = this.http.get(this.BASE_URL,{
      params : {
        met:'Fixtures',
        APIkey:process.env['APIKEY']!,
        matchId: matchId
      }
    });
    const videos = this.http.get(this.BASE_URL,{
      params : {
        met:'Videos',
        APIkey:process.env['APIKEY']!,
        eventId: matchId
      }
    });
    const h2h = this.http.get(this.BASE_URL,{
      params : {
        met:'H2H',
        APIkey:process.env['APIKEY']!,
        firstTeamId: 'team1',
        secondTeamId: 'team2'
      }
    });

    return forkJoin({
      generalInfo,
      highlights: videos,
      h2h
    }).pipe(
      map(({ generalInfo, highlights, h2h }) => ({ ...generalInfo, highlights, h2h }))
    );
  }
}
