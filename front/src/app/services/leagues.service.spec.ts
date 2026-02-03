import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { LeaguesService } from './leagues.service';
import { League, LeaguesResponse } from '../models/models';
import { environment } from '../../environments/environment';

describe('LeaguesService', () => {
  let service: LeaguesService;
  let httpMock: HttpTestingController;
  const API_BASE_URL = environment.allSportsApi.baseUrl;

  const mockLeagues: League[] = [
    {
      league_key: '152',
      league_name: 'Premier League',
      country_key: '44',
      country_name: 'England',
      league_logo: 'https://example.com/pl.png',
      country_logo: 'https://example.com/england.png'
    },
    {
      league_key: '302',
      league_name: 'La Liga',
      country_key: '6',
      country_name: 'Spain',
      league_logo: 'https://example.com/laliga.png',
      country_logo: 'https://example.com/spain.png'
    }
  ];

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [LeaguesService]
    });
    service = TestBed.inject(LeaguesService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('getAllLeagues', () => {

    it('should return empty array on error', (done) => {
      service.getAllLeagues().subscribe(leagues => {
        expect(leagues).toEqual([]);
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL && request.params.get('met') === 'Leagues';
      });
      req.error(new ProgressEvent('error'));
    });

    it('should handle response without result property', (done) => {
      const mockResponse: any = {
        success: 1
      };

      service.getAllLeagues().subscribe(leagues => {
        expect(leagues).toEqual([]);
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL && request.params.get('met') === 'Leagues';
      });
      req.flush(mockResponse);
    });
  });

  describe('getFeaturedLeagues', () => {
    it('should return featured leagues', (done) => {
      const mockResponse: LeaguesResponse = {
        success: 1,
        result: mockLeagues
      };

      service.getFeaturedLeagues().subscribe(leagues => {
        expect(leagues.length).toBeGreaterThan(0);
        leagues.forEach(league => {
          // Only featured league IDs should be returned
          expect(['152', '302']).toContain(league.league_key);
        });
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL && request.params.get('met') === 'Leagues';
      });
      req.flush(mockResponse);
    });

    it('should sort featured leagues by FEATURED_LEAGUE_IDS order', (done) => {
      const mockResponse: LeaguesResponse = {
        success: 1,
        result: [mockLeagues[1], mockLeagues[0]] // La Liga first, then Premier League
      };

      service.getFeaturedLeagues().subscribe(leagues => {
        // Should be sorted: Premier League (152) first, then La Liga (302)
        expect(leagues[0].league_key).toBe('152');
        expect(leagues[1].league_key).toBe('302');
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL && request.params.get('met') === 'Leagues';
      });
      req.flush(mockResponse);
    });
  });

  describe('searchLeagues', () => {
    it('should search leagues by name', (done) => {
      const mockResponse: LeaguesResponse = {
        success: 1,
        result: mockLeagues
      };

      service.searchLeagues('Premier').subscribe(leagues => {
        expect(leagues.length).toBe(1);
        expect(leagues[0].league_name).toBe('Premier League');
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL && request.params.get('met') === 'Leagues';
      });
      req.flush(mockResponse);
    });

    it('should search leagues by country name', (done) => {
      const mockResponse: LeaguesResponse = {
        success: 1,
        result: mockLeagues
      };

      service.searchLeagues('Spain').subscribe(leagues => {
        expect(leagues.length).toBe(1);
        expect(leagues[0].country_name).toBe('Spain');
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL && request.params.get('met') === 'Leagues';
      });
      req.flush(mockResponse);
    });

    it('should be case insensitive', (done) => {
      const mockResponse: LeaguesResponse = {
        success: 1,
        result: mockLeagues
      };

      service.searchLeagues('PREMIER').subscribe(leagues => {
        expect(leagues.length).toBe(1);
        expect(leagues[0].league_name).toBe('Premier League');
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL && request.params.get('met') === 'Leagues';
      });
      req.flush(mockResponse);
    });

    it('should return empty array if no matches found', (done) => {
      const mockResponse: LeaguesResponse = {
        success: 1,
        result: mockLeagues
      };

      service.searchLeagues('NonExistent').subscribe(leagues => {
        expect(leagues.length).toBe(0);
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL && request.params.get('met') === 'Leagues';
      });
      req.flush(mockResponse);
    });

    it('should match partial strings', (done) => {
      const mockResponse: LeaguesResponse = {
        success: 1,
        result: mockLeagues
      };

      service.searchLeagues('Leag').subscribe(leagues => {
        expect(leagues.length).toBeGreaterThan(0);
        leagues.forEach(league => {
          expect(league.league_name.toLowerCase()).toContain('leag');
        });
        done();
      });

      const req = httpMock.expectOne(request => {
        return request.url === API_BASE_URL && request.params.get('met') === 'Leagues';
      });
      req.flush(mockResponse);
    });
  });
});
