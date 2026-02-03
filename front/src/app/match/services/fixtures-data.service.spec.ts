import { TestBed, fakeAsync, tick } from '@angular/core/testing';
import { signal } from '@angular/core';
import { of, Subject, throwError } from 'rxjs';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

import { FixturesApiService } from './fixtures-api.service';
import { FixturesResourceFactory, FixturesRequest } from './fixtures-resource.factory';
import { LiveEventsService } from './live-events.service';
import { Fixture, League } from '../types/fixture.types';

describe('FixturesApiService', () => {
  let service: FixturesApiService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [FixturesApiService]
    });

    service = TestBed.inject(FixturesApiService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('getFixtures', () => {
    it('should fetch fixtures for a date range', fakeAsync(() => {
      const mockFixtures: Fixture[] = [
        {
          event_key: '12345',
          event_date: '2026-02-03',
          event_time: '20:00',
          event_home_team: 'Manchester United',
          event_away_team: 'Liverpool',
          event_final_result: '2-1',
          event_halftime_result: '1-0',
          event_status: 'Finished',
          event_live: '0',
          home_team_key: '100',
          away_team_key: '200',
          home_team_logo: 'http://logo.com/manu.png',
          away_team_logo: 'http://logo.com/liverpool.png',
          league_name: 'Premier League',
          league_key: '152',
          league_logo: 'http://logo.com/epl.png',
          country_name: 'England',
          event_stadium: 'Old Trafford'
        }
      ];

      const mockResponse = { success: 1, result: mockFixtures };

      service.getFixtures('2026-02-03', '2026-02-03').subscribe(fixtures => {
        expect(fixtures.length).toBe(1);
        expect(fixtures[0].event_home_team).toBe('Manchester United');
        expect(fixtures[0].event_away_team).toBe('Liverpool');
      });

      const req = httpMock.expectOne((request) => {
        return request.url.includes('met=Fixtures') &&
          request.url.includes('from=2026-02-03') &&
          request.url.includes('to=2026-02-03');
      });
      expect(req.request.method).toBe('GET');
      req.flush(mockResponse);
    }));

    it('should fetch fixtures filtered by league', fakeAsync(() => {
      const mockFixtures: Fixture[] = [
        {
          event_key: '12345',
          event_date: '2026-02-03',
          event_time: '20:00',
          event_home_team: 'Barcelona',
          event_away_team: 'Real Madrid',
          event_final_result: '3-2',
          event_halftime_result: '2-1',
          event_status: 'Finished',
          event_live: '0',
          home_team_key: '300',
          away_team_key: '400',
          home_team_logo: 'http://logo.com/barca.png',
          away_team_logo: 'http://logo.com/madrid.png',
          league_name: 'La Liga',
          league_key: '302',
          league_logo: 'http://logo.com/laliga.png',
          country_name: 'Spain',
          event_stadium: 'Camp Nou'
        }
      ];

      const mockResponse = { success: 1, result: mockFixtures };

      service.getFixtures('2026-02-03', '2026-02-03', '302').subscribe(fixtures => {
        expect(fixtures.length).toBe(1);
        expect(fixtures[0].league_key).toBe('302');
      });

      const req = httpMock.expectOne((request) => {
        return request.url.includes('met=Fixtures') &&
          request.url.includes('leagueId=302');
      });
      expect(req.request.method).toBe('GET');
      req.flush(mockResponse);
    }));

    it('should handle empty result', fakeAsync(() => {
      const mockResponse = { success: 1, result: [] };

      service.getFixtures('2026-02-03', '2026-02-03').subscribe(fixtures => {
        expect(fixtures).toEqual([]);
      });

      const req = httpMock.expectOne((request) => request.url.includes('met=Fixtures'));
      req.flush(mockResponse);
    }));

    it('should handle API error gracefully', fakeAsync(() => {
      service.getFixtures('2026-02-03', '2026-02-03').subscribe(fixtures => {
        expect(fixtures).toEqual([]);
      });

      const req = httpMock.expectOne((request) => request.url.includes('met=Fixtures'));
      req.error(new ErrorEvent('Network error'));
    }));
  });

  describe('getLiveMatches', () => {
    it('should fetch live matches', fakeAsync(() => {
      const mockLiveMatches: Fixture[] = [
        {
          event_key: '55555',
          event_date: '2026-02-03',
          event_time: '20:00',
          event_home_team: 'Arsenal',
          event_away_team: 'Chelsea',
          event_final_result: '1-1',
          event_halftime_result: '0-1',
          event_status: '67',
          event_live: '1',
          home_team_key: '500',
          away_team_key: '600',
          home_team_logo: 'http://logo.com/arsenal.png',
          away_team_logo: 'http://logo.com/chelsea.png',
          league_name: 'Premier League',
          league_key: '152',
          league_logo: 'http://logo.com/epl.png',
          country_name: 'England',
          event_stadium: 'Emirates Stadium'
        }
      ];

      const mockResponse = { success: 1, result: mockLiveMatches };

      service.getLiveMatches().subscribe(matches => {
        expect(matches.length).toBe(1);
        expect(matches[0].event_live).toBe('1');
        expect(matches[0].event_status).toBe('67');
      });

      const req = httpMock.expectOne((request) =>
        request.url.includes('met=Livescore')
      );
      expect(req.request.method).toBe('GET');
      req.flush(mockResponse);
    }));

    it('should handle no live matches', fakeAsync(() => {
      const mockResponse = { success: 1, result: [] };

      service.getLiveMatches().subscribe(matches => {
        expect(matches).toEqual([]);
      });

      const req = httpMock.expectOne((request) => request.url.includes('met=Livescore'));
      req.flush(mockResponse);
    }));
  });

  describe('getAllLeagues', () => {
    it('should fetch all leagues', fakeAsync(() => {
      const mockLeagues: League[] = [
        {
          league_key: '152',
          league_name: 'Premier League',
          league_logo: 'http://logo.com/epl.png',
          country_name: 'England'
        },
        {
          league_key: '302',
          league_name: 'La Liga',
          league_logo: 'http://logo.com/laliga.png',
          country_name: 'Spain'
        }
      ];

      const mockResponse = { success: 1, result: mockLeagues };

      service.getAllLeagues().subscribe(leagues => {
        expect(leagues.length).toBe(2);
        expect(leagues[0].league_name).toBe('Premier League');
        expect(leagues[1].league_name).toBe('La Liga');
      });

      const req = httpMock.expectOne((request) =>
        request.url.includes('met=Leagues')
      );
      expect(req.request.method).toBe('GET');
      req.flush(mockResponse);
    }));
  });

  describe('getFeaturedLeagues', () => {
    it('should fetch and filter featured leagues', fakeAsync(() => {
      const mockLeagues: League[] = [
        {
          league_key: '152',
          league_name: 'Premier League',
          league_logo: 'http://logo.com/epl.png',
          country_name: 'England'
        },
        {
          league_key: '302',
          league_name: 'La Liga',
          league_logo: 'http://logo.com/laliga.png',
          country_name: 'Spain'
        },
        {
          league_key: '999',
          league_name: 'Random League',
          league_logo: 'http://logo.com/random.png',
          country_name: 'Random'
        }
      ];

      const mockResponse = { success: 1, result: mockLeagues };

      service.getFeaturedLeagues().subscribe(leagues => {
        expect(leagues.length).toBe(2);
        expect(leagues[0].league_key).toBe('152');
        expect(leagues[1].league_key).toBe('302');
        expect(leagues.find(l => l.league_key === '999')).toBeUndefined();
      });

      const req = httpMock.expectOne((request) => request.url.includes('met=Leagues'));
      req.flush(mockResponse);
    }));
  });

  describe('getLeaguesByCountry', () => {
    it('should fetch leagues for a specific country', fakeAsync(() => {
      const mockLeagues: League[] = [
        {
          league_key: '152',
          league_name: 'Premier League',
          league_logo: 'http://logo.com/epl.png',
          country_name: 'England'
        },
        {
          league_key: '153',
          league_name: 'Championship',
          league_logo: 'http://logo.com/championship.png',
          country_name: 'England'
        }
      ];

      const mockResponse = { success: 1, result: mockLeagues };

      service.getLeaguesByCountry('41').subscribe(leagues => {
        expect(leagues.length).toBe(2);
        expect(leagues.every(l => l.country_name === 'England')).toBe(true);
      });

      const req = httpMock.expectOne((request) =>
        request.url.includes('met=Leagues') &&
        request.url.includes('countryId=41')
      );
      expect(req.request.method).toBe('GET');
      req.flush(mockResponse);
    }));
  });
});

describe('FixturesResourceFactory', () => {
  let factory: FixturesResourceFactory;
  let mockApiService: jasmine.SpyObj<FixturesApiService>;
  let mockLiveService: jasmine.SpyObj<LiveEventsService>;
  let liveEventsSubject: Subject<any>;

  const mockFixtures: Fixture[] = [
    {
      event_key: '12345',
      event_date: '2026-02-03',
      event_time: '20:00',
      event_home_team: 'Manchester United',
      event_away_team: 'Liverpool',
      event_final_result: '2-1',
      event_halftime_result: '1-0',
      event_status: 'Finished',
      event_live: '0',
      home_team_key: '100',
      away_team_key: '200',
      home_team_logo: 'http://logo.com/manu.png',
      away_team_logo: 'http://logo.com/liverpool.png',
      league_name: 'Premier League',
      league_key: '152',
      league_logo: 'http://logo.com/epl.png',
      country_name: 'England',
      event_stadium: 'Old Trafford'
    },
    {
      event_key: '67890',
      event_date: '2026-02-03',
      event_time: '18:00',
      event_home_team: 'Arsenal',
      event_away_team: 'Chelsea',
      event_final_result: '1-1',
      event_halftime_result: '0-1',
      event_status: '75',
      event_live: '1',
      home_team_key: '500',
      away_team_key: '600',
      home_team_logo: 'http://logo.com/arsenal.png',
      away_team_logo: 'http://logo.com/chelsea.png',
      league_name: 'Premier League',
      league_key: '152',
      league_logo: 'http://logo.com/epl.png',
      country_name: 'England',
      event_stadium: 'Emirates Stadium'
    }
  ];

  beforeEach(() => {
    liveEventsSubject = new Subject<any>();

    mockApiService = jasmine.createSpyObj('FixturesApiService', [
      'getFixtures',
      'getLiveMatches',
      'getAllLeagues',
      'getFeaturedLeagues',
      'getLeaguesByCountry'
    ]);
    mockLiveService = jasmine.createSpyObj('LiveEventsService', [], {
      events$: liveEventsSubject.asObservable()
    });

    TestBed.configureTestingModule({
      providers: [
        FixturesResourceFactory,
        { provide: FixturesApiService, useValue: mockApiService },
        { provide: LiveEventsService, useValue: mockLiveService }
      ]
    });

    factory = TestBed.inject(FixturesResourceFactory);
  });

  it('should be created', () => {
    expect(factory).toBeTruthy();
  });

  describe('create', () => {
    it('should return resource and signals', () => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03',
        leagueId: 'all'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      expect(result.resource).toBeDefined();
      expect(result.fixtures).toBeDefined();
      expect(result.lastUpdate).toBeDefined();
    });

    it('should initialize with empty fixtures', () => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(of([]));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      expect(result.fixtures()).toEqual([]);
      expect(result.lastUpdate()).toBeNull();
    });

    it('should load fixtures from API', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03',
        leagueId: '152'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      expect(mockApiService.getFixtures).toHaveBeenCalledWith('2026-02-03', '2026-02-03', '152');
      expect(result.fixtures().length).toBe(2);
      expect(result.lastUpdate()).toBeDefined();
    }));

    it('should handle API errors gracefully', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(throwError(() => new Error('API Error')));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      expect(result.fixtures()).toEqual([]);
    }));
  });

  describe('live updates', () => {
    it('should update score on GOAL_SCORED event', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      const initialFixture = result.fixtures()[1];
      expect(initialFixture.event_final_result).toBe('1-1');

      liveEventsSubject.next({
        match_id: '67890',
        type: 'GOAL_SCORED',
        team: 'home',
        scorer: 'Saka',
        minute: '78',
        score: '2-1'
      });

      tick();

      const updatedFixture = result.fixtures().find((f: Fixture) => f.event_key === '67890');
      expect(updatedFixture?.event_final_result).toBe('2-1');
      expect(updatedFixture?.event_live).toBe('1');
    }));

    it('should update score on SCORE_UPDATE event', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      liveEventsSubject.next({
        match_id: '67890',
        type: 'SCORE_UPDATE',
        score: '2-2'
      });

      tick();

      const updatedFixture = result.fixtures().find((f: Fixture) => f.event_key === '67890');
      expect(updatedFixture?.event_final_result).toBe('2-2');
    }));

    it('should update status on MATCH_STARTED event', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      const scheduledFixture = { ...mockFixtures[0], event_live: '0', event_status: '' };
      mockApiService.getFixtures.and.returnValue(of([scheduledFixture]));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      liveEventsSubject.next({
        match_id: '12345',
        type: 'MATCH_STARTED'
      });

      tick();

      const updatedFixture = result.fixtures().find((f: Fixture) => f.event_key === '12345');
      expect(updatedFixture?.event_live).toBe('1');
      expect(updatedFixture?.event_status).toBe('1');
    }));

    it('should update status on HALF_TIME event', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      liveEventsSubject.next({
        match_id: '67890',
        type: 'HALF_TIME',
        halftime_score: '1-0'
      });

      tick();

      const updatedFixture = result.fixtures().find((f: Fixture) => f.event_key === '67890');
      expect(updatedFixture?.event_status).toBe('Half Time');
      expect(updatedFixture?.event_halftime_result).toBe('1-0');
    }));

    it('should update status on SECOND_HALF_STARTED event', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      liveEventsSubject.next({
        match_id: '67890',
        type: 'SECOND_HALF_STARTED'
      });

      tick();

      const updatedFixture = result.fixtures().find((f: Fixture) => f.event_key === '67890');
      expect(updatedFixture?.event_status).toBe('46');
      expect(updatedFixture?.event_live).toBe('1');
    }));

    it('should update status on MATCH_ENDED event', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      liveEventsSubject.next({
        match_id: '67890',
        type: 'MATCH_ENDED',
        final_score: '2-1'
      });

      tick();

      const updatedFixture = result.fixtures().find((f: Fixture) => f.event_key === '67890');
      expect(updatedFixture?.event_live).toBe('0');
      expect(updatedFixture?.event_status).toBe('Finished');
      expect(updatedFixture?.event_final_result).toBe('2-1');
    }));

    it('should create new fixture if not found on live event', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      const initialLength = result.fixtures().length;

      liveEventsSubject.next({
        match_id: 'new-match-999',
        type: 'GOAL_SCORED',
        team: 'home',
        scorer: 'Kane',
        minute: '12',
        score: '1-0',
        home_team: 'Bayern Munich',
        away_team: 'Dortmund',
        league: 'Bundesliga'
      });

      tick();

      const updatedFixtures = result.fixtures();
      expect(updatedFixtures.length).toBe(initialLength + 1);

      const newFixture = updatedFixtures.find((f: Fixture) => f.event_key === 'new-match-999');
      expect(newFixture).toBeDefined();
      expect(newFixture?.event_home_team).toBe('Bayern Munich');
      expect(newFixture?.event_away_team).toBe('Dortmund');
      expect(newFixture?.event_final_result).toBe('1-0');
    }));

    it('should ignore non-fixture events', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      const initialFixtures = [...result.fixtures()];

      liveEventsSubject.next({
        match_id: '67890',
        type: 'UNKNOWN_EVENT'
      });

      tick();

      expect(result.fixtures()).toEqual(initialFixtures);
    }));

    it('should update lastUpdate timestamp on live events', fakeAsync(() => {
      const requestSignal = signal<FixturesRequest>({
        from: '2026-02-03',
        to: '2026-02-03'
      });
      mockApiService.getFixtures.and.returnValue(of(mockFixtures));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(requestSignal)
      );

      tick();

      const initialUpdate = result.lastUpdate();

      tick(1000);

      liveEventsSubject.next({
        match_id: '67890',
        type: 'GOAL_SCORED',
        team: 'away',
        scorer: 'Palmer',
        minute: '85',
        score: '1-2'
      });

      tick();

      const updatedTimestamp = result.lastUpdate();
      expect(updatedTimestamp).not.toBe(initialUpdate);
      expect(updatedTimestamp).toBeDefined();
    }));
  });

  describe('createFeaturedLeaguesResource', () => {
    it('should return resource and signals for featured leagues', () => {
      const mockLeagues: League[] = [
        {
          league_key: '152',
          league_name: 'Premier League',
          league_logo: 'http://logo.com/epl.png',
          country_name: 'England'
        }
      ];
      mockApiService.getFeaturedLeagues.and.returnValue(of(mockLeagues));

      const result = TestBed.runInInjectionContext(() =>
        factory.createFeaturedLeaguesResource()
      );

      expect(result.resource).toBeDefined();
      expect(result.leagues).toBeDefined();
      expect(result.loading).toBeDefined();
    });

    it('should load featured leagues', fakeAsync(() => {
      const mockLeagues: League[] = [
        {
          league_key: '152',
          league_name: 'Premier League',
          league_logo: 'http://logo.com/epl.png',
          country_name: 'England'
        },
        {
          league_key: '302',
          league_name: 'La Liga',
          league_logo: 'http://logo.com/laliga.png',
          country_name: 'Spain'
        }
      ];
      mockApiService.getFeaturedLeagues.and.returnValue(of(mockLeagues));

      const result = TestBed.runInInjectionContext(() =>
        factory.createFeaturedLeaguesResource()
      );

      tick();

      expect(result.leagues().length).toBe(2);
      expect(result.leagues()[0].league_name).toBe('Premier League');
      expect(result.loading()).toBe(false);
    }));

    it('should handle API error when loading featured leagues', fakeAsync(() => {
      mockApiService.getFeaturedLeagues.and.returnValue(throwError(() => new Error('API Error')));

      const result = TestBed.runInInjectionContext(() =>
        factory.createFeaturedLeaguesResource()
      );

      tick();

      expect(result.loading()).toBe(false);
      expect(result.leagues()).toEqual([]);
    }));
  });
});

