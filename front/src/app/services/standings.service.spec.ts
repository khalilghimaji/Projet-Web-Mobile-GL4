import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { StandingsService } from './standings.service';
import { StandingsResponse, StandingEntry } from '../models/models';
import { environment } from '../../environments/environment';

describe('StandingsService', () => {
  let service: StandingsService;
  let httpMock: HttpTestingController;
  const API_BASE_URL = environment.allSportsApi.baseUrl;

  const mockStandingEntry: StandingEntry = {
    standing_place: '1',
    standing_place_type: null,
    standing_team: 'Test Team',
    standing_P: '10',
    standing_W: '8',
    standing_D: '1',
    standing_L: '1',
    standing_F: '25',
    standing_A: '10',
    standing_GD: '15',
    standing_PTS: '25',
    team_key: '123',
    league_key: '152',
    league_season: '2024',
    league_round: '10'
  };

  const mockStandingsResponse: StandingsResponse = {
    success: 1,
    result: {
      total: [mockStandingEntry],
      home: [mockStandingEntry],
      away: [mockStandingEntry]
    }
  };

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [StandingsService]
    });
    service = TestBed.inject(StandingsService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
    service.clearCache(); // Clear cache after each test
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('getStandings', () => {
    it('should fetch standings for a specific league', (done) => {
      const leagueId = '152';

      service.getStandings(leagueId).subscribe(response => {
        expect(response).toEqual(mockStandingsResponse);
        expect(response.result.total.length).toBe(1);
        expect(response.result.total[0].standing_team).toBe('Test Team');
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL &&
          request.params.get('met') === 'Standings' &&
          request.params.get('leagueId') === leagueId;
      });
      expect(req.request.method).toBe('GET');
      req.flush(mockStandingsResponse);
    });

    it('should update cache when fetching standings', (done) => {
      const leagueId = '152';

      service.getStandings(leagueId).subscribe(() => {
        service.getCachedStandings(leagueId).subscribe(cached => {
          expect(cached).toEqual(mockStandingsResponse);
          done();
        });
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL &&
          request.params.get('met') === 'Standings' &&
          request.params.get('leagueId') === leagueId;
      });
      req.flush(mockStandingsResponse);
    });

    it('should handle errors when fetching standings', (done) => {
      const leagueId = '152';

      service.getStandings(leagueId).subscribe({
        next: () => fail('should have failed'),
        error: (error) => {
          expect(error).toBeDefined();
          done();
        }
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL &&
          request.params.get('met') === 'Standings' &&
          request.params.get('leagueId') === leagueId;
      });
      req.error(new ProgressEvent('error'));
    });
  });

  describe('getCachedStandings', () => {
    it('should return cached standings if available', (done) => {
      const leagueId = '152';

      // First call should fetch from API
      service.getCachedStandings(leagueId).subscribe();

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL &&
          request.params.get('met') === 'Standings' &&
          request.params.get('leagueId') === leagueId;
      });
      req.flush(mockStandingsResponse);

      // Second call should return cached data
      service.getCachedStandings(leagueId).subscribe(cached => {
        expect(cached).toEqual(mockStandingsResponse);
        done();
      });

      // No additional HTTP request should be made
      httpMock.expectNone(request => {
        return request.url === API_BASE_URL;
      });
    });

    it('should initialize cache with null if not exists', (done) => {
      const leagueId = '999';

      service.getCachedStandings(leagueId).subscribe(cached => {
        if (cached === null) {
          expect(cached).toBeNull();
          done();
        }
      });

      // Should trigger a fetch
      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL &&
          request.params.get('leagueId') === leagueId;
      });
      req.flush(mockStandingsResponse);
    });

    it('should fetch data automatically if not cached', (done) => {
      const leagueId = '152';
      let emissionCount = 0;

      service.getCachedStandings(leagueId).subscribe(standings => {
        emissionCount++;
        if (emissionCount === 1) {
          // First emission should be null
          expect(standings).toBeNull();
        } else if (emissionCount === 2) {
          // Second emission should have data
          expect(standings).toEqual(mockStandingsResponse);
          done();
        }
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL &&
          request.params.get('leagueId') === leagueId;
      });
      req.flush(mockStandingsResponse);
    });
  });

  describe('refreshStandings', () => {
    it('should fetch fresh standings data', () => {
      const leagueId = '152';

      service.refreshStandings(leagueId);

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL &&
          request.params.get('met') === 'Standings' &&
          request.params.get('leagueId') === leagueId;
      });
      expect(req.request.method).toBe('GET');
      req.flush(mockStandingsResponse);
    });

    it('should update cache with fresh data', (done) => {
      const leagueId = '152';

      // Initial fetch
      service.getStandings(leagueId).subscribe(() => {
        // Refresh
        service.refreshStandings(leagueId);

        const req = httpMock.expectOne(request => {
          return request.url === API_BASE_URL &&
            request.params.get('leagueId') === leagueId;
        });
        req.flush(mockStandingsResponse);

        // Verify cache was updated
        service.getCachedStandings(leagueId).subscribe(cached => {
          expect(cached).toEqual(mockStandingsResponse);
          done();
        });
      });

      const initialReq = httpMock.expectOne(request => {
        return request.url === API_BASE_URL &&
          request.params.get('leagueId') === leagueId;
      });
      initialReq.flush(mockStandingsResponse);
    });
  });

  describe('clearCache', () => {
    it('should clear cache for specific league', (done) => {
      const leagueId = '152';

      // Populate cache
      service.getStandings(leagueId).subscribe(() => {
        // Clear specific league
        service.clearCache(leagueId);

        // Next call should fetch from API again
        service.getCachedStandings(leagueId).subscribe();

        const req = httpMock.expectOne(request => {
          return request.url === API_BASE_URL &&
            request.params.get('leagueId') === leagueId;
        });
        req.flush(mockStandingsResponse);
        done();
      });

      const initialReq = httpMock.expectOne(request => {
        return request.url === API_BASE_URL &&
          request.params.get('leagueId') === leagueId;
      });
      initialReq.flush(mockStandingsResponse);
    });

    it('should clear all cache when no leagueId provided', (done) => {
      const leagueId1 = '152';
      const leagueId2 = '302';

      // Populate cache for multiple leagues
      service.getStandings(leagueId1).subscribe();
      service.getStandings(leagueId2).subscribe();

      const req1 = httpMock.expectOne(request => request.params.get('leagueId') === leagueId1);
      const req2 = httpMock.expectOne(request => request.params.get('leagueId') === leagueId2);
      req1.flush(mockStandingsResponse);
      req2.flush(mockStandingsResponse);

      // Clear all cache
      service.clearCache();

      // Both should fetch from API again
      service.getCachedStandings(leagueId1).subscribe();
      service.getCachedStandings(leagueId2).subscribe();

      const newReq1 = httpMock.expectOne(request => request.params.get('leagueId') === leagueId1);
      const newReq2 = httpMock.expectOne(request => request.params.get('leagueId') === leagueId2);
      expect(newReq1).toBeDefined();
      expect(newReq2).toBeDefined();
      newReq1.flush(mockStandingsResponse);
      newReq2.flush(mockStandingsResponse);
      done();
    });
  });
});
