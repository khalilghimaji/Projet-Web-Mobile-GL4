import {HttpClient} from '@angular/common/http';
import {inject, Injectable} from '@angular/core';

@Injectable({ providedIn: 'root' })
export class MatchApiService {
  private http = inject(HttpClient);

  getMatch(matchId: string) {
    return this.http.get<MatchDto>(`/api/matches/${matchId}`);
  }
}
