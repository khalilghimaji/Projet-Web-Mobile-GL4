import { TestBed, fakeAsync, tick } from '@angular/core/testing';
import { signal } from '@angular/core';
import { of, Subject, throwError } from 'rxjs';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

import { MatchResourceFactory } from './match-resource.factory';
import { MatchApiService } from './match-api.service';
import { LiveEventsService } from './live-events.service';


describe('MatchApiService', () => {
  let service: MatchApiService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [MatchApiService]
    });

    service = TestBed.inject(MatchApiService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('getMatch', () => {
    it('should fetch match data and combine with highlights and h2h', fakeAsync(() => {
      const matchId = '12345';
      const mockGeneralInfo = {
        result: [{
          event_key: matchId,
          event_home_team: 'Team A',
          event_away_team: 'Team B',
          event_final_result: '2-1',
          event_status: 'Finished',
          event_live: '0',
          home_team_key: '100',
          away_team_key: '200',
          league_name: 'Premier League',
          goalscorers: [],
          substitutes: [],
          cards: [],
          statistics: [],
          lineups: {}
        }]
      };

      const mockHighlights = {
        success: '1',
        result: [{ video_title: 'Goal 1', video_url: 'http://video.com/1' }]
      };

      const mockH2H = {
        success: '1',
        result: { H2H: [{ event_final_result: '1-0' }] }
      };

      service.getMatch(matchId).subscribe(result => {
        expect(result.event_key).toBe(matchId);
        expect(result.event_home_team).toBe('Team A');
        expect(result.highlights.length).toBe(1);
        expect(result.h2h.H2H.length).toBe(1);
      });

      // Handle general info request
      const generalReq = httpMock.expectOne(req =>
        req.url.includes('allsportsapi.com') && req.params.get('met') === 'Fixtures'
      );
      generalReq.flush(mockGeneralInfo);

      tick();

      // Handle videos request
      const videosReq = httpMock.expectOne(req =>
        req.url.includes('allsportsapi.com') && req.params.get('met') === 'Videos'
      );
      videosReq.flush(mockHighlights);

      // Handle H2H request
      const h2hReq = httpMock.expectOne(req =>
        req.url.includes('allsportsapi.com') && req.params.get('met') === 'H2H'
      );
      h2hReq.flush(mockH2H);

      tick();
    }));

    it('should handle empty highlights when API fails', fakeAsync(() => {
      const matchId = '12345';
      const mockGeneralInfo = {
        result: [{
          event_key: matchId,
          event_home_team: 'Team A',
          event_away_team: 'Team B',
          event_final_result: '0-0',
          event_status: 'Finished',
          event_live: '0',
          home_team_key: '100',
          away_team_key: '200',
          goalscorers: [],
          substitutes: [],
          cards: [],
          statistics: [],
          lineups: {}
        }]
      };

      const mockHighlightsFailure = { success: '0' };
      const mockH2H = { success: '1', result: { H2H: [] } };

      service.getMatch(matchId).subscribe(result => {
        expect(result.highlights).toEqual([]);
      });

      const generalReq = httpMock.expectOne(req => req.params.get('met') === 'Fixtures');
      generalReq.flush(mockGeneralInfo);

      tick();

      const videosReq = httpMock.expectOne(req => req.params.get('met') === 'Videos');
      videosReq.flush(mockHighlightsFailure);

      const h2hReq = httpMock.expectOne(req => req.params.get('met') === 'H2H');
      h2hReq.flush(mockH2H);

      tick();
    }));
  });
});

describe('LiveEventsService', () => {
  let service: LiveEventsService;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [LiveEventsService]
    });

    service = TestBed.inject(LiveEventsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('should have events$ observable', () => {
    expect(service.events$).toBeDefined();
  });
});

describe('MatchResourceFactory', () => {
  let factory: MatchResourceFactory;
  let mockApiService: jasmine.SpyObj<MatchApiService>;
  let mockLiveService: jasmine.SpyObj<LiveEventsService>;
  let liveEventsSubject: Subject<any>;

  const mockMatchDto = {
    event_key: '12345',
    event_home_team: 'Manchester United',
    event_away_team: 'Liverpool',
    event_final_result: '2-1',
    event_status: 'Finished',
    event_live: '0',
    home_team_key: '100',
    away_team_key: '200',
    home_team_logo: 'http://logo.com/manu.png',
    away_team_logo: 'http://logo.com/liverpool.png',
    event_stadium: 'Old Trafford',
    league_name: 'Premier League',
    event_home_formation: '4-3-3',
    event_away_formation: '4-4-2',
    goalscorers: [
      { time: '23', home_scorer: 'Rashford', home_assist: 'Bruno' },
      { time: '67', away_scorer: 'Salah', away_assist: '' }
    ],
    substitutes: [],
    cards: [
      { time: '45', card: 'yellow card', home_fault: 'McTominay' }
    ],
    statistics: [
      { type: 'Possession', home: '55', away: '45' },
      { type: 'Shots', home: '12', away: '8' }
    ],
    lineups: {
      home_team: { starting_lineups: [] },
      away_team: { starting_lineups: [] }
    },
    highlights: [],
    h2h: { H2H: [{ event_final_result: '1-1' }] }
  };

  beforeEach(() => {
    liveEventsSubject = new Subject<any>();

    mockApiService = jasmine.createSpyObj('MatchApiService', ['getMatch']);
    mockLiveService = jasmine.createSpyObj('LiveEventsService', [], {
      events$: liveEventsSubject.asObservable()
    });

    TestBed.configureTestingModule({
      providers: [
        MatchResourceFactory,
        { provide: MatchApiService, useValue: mockApiService },
        { provide: LiveEventsService, useValue: mockLiveService }
      ]
    });

    factory = TestBed.inject(MatchResourceFactory);
  });

  it('should be created', () => {
    expect(factory).toBeTruthy();
  });

  describe('create', () => {
    it('should return signals and resource', () => {
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );

      expect(result.resource).toBeDefined();
      expect(result.matchHeaderSignal).toBeDefined();
      expect(result.timelineSignal).toBeDefined();
      expect(result.lineupsSignal).toBeDefined();
      expect(result.statsSignal).toBeDefined();
      expect(result.h2hSignal).toBeDefined();
      expect(result.highlightsSignal).toBeDefined();
    });

    it('should initialize signals with default values', () => {
      const matchIdSignal = signal<string | undefined>(undefined);
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );

      const header = result.matchHeaderSignal();
      expect(header.status.status).toBe('SCHEDULED');
      expect(header.score.home).toBe(0);
      expect(header.score.away).toBe(0);
      expect(result.timelineSignal()).toEqual([]);
    });
  });

  describe('hydrateFromSnapshot', () => {
    it('should populate matchHeaderSignal from API response', fakeAsync(() => {
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );

      // Trigger the resource
      tick();

      const header = result.matchHeaderSignal();
      expect(header.homeTeam.name).toBe('Manchester United');
      expect(header.awayTeam.name).toBe('Liverpool');
      expect(header.score.home).toBe(2);
      expect(header.score.away).toBe(1);
      expect(header.status.status).toBe('FT');
      expect(header.status.competition).toBe('Premier League');
    }));

    it('should populate timelineSignal with goals and cards', fakeAsync(() => {
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      const timeline = result.timelineSignal();
      expect(timeline.length).toBe(3); // 2 goals + 1 card

      const goal = timeline.find(e => e.type === 'GOAL' && e.player === 'Rashford');
      expect(goal).toBeDefined();
      expect(goal?.team).toBe('home');
      expect(goal?.detail).toContain('Bruno');

      const card = timeline.find(e => e.type === 'YELLOW_CARD');
      expect(card).toBeDefined();
      expect(card?.player).toBe('McTominay');
    }));

    it('should populate statsSignal from API response', fakeAsync(() => {
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      const stats = result.statsSignal();
      expect(stats.stats.length).toBe(2);

      const possession = stats.stats.find(s => s.label === 'Possession');
      expect(possession?.homeValue).toBe(55);
      expect(possession?.awayValue).toBe(45);
    }));

    it('should populate h2hSignal from API response', fakeAsync(() => {
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      const h2h = result.h2hSignal();
      expect(h2h.homeTeamLogo).toBe('http://logo.com/manu.png');
      expect(h2h.awayTeamLogo).toBe('http://logo.com/liverpool.png');
      expect(h2h.recentForm.length).toBe(1);
      expect(h2h.recentForm[0]).toBe('D'); // 1-1 is a draw
    }));
  });

  describe('applyEvent (live updates)', () => {
    it('should update score on GOAL_SCORED event', fakeAsync(() => {
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      const initialScore = result.matchHeaderSignal().score;
      expect(initialScore.home).toBe(2);

      // Simulate live goal event
      liveEventsSubject.next({
        match_id: '12345',
        type: 'GOAL_SCORED',
        team: 'home',
        scorer: 'Martial',
        minute: '89'
      });
      tick();

      const updatedScore = result.matchHeaderSignal().score;
      expect(updatedScore.home).toBe(3);
    }));

    it('should add event to timeline on CARD_ISSUED event', fakeAsync(() => {
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      const initialTimeline = result.timelineSignal();
      const initialCount = initialTimeline.length;

      liveEventsSubject.next({
        match_id: '12345',
        type: 'CARD_ISSUED',
        team: 'away',
        player: 'Van Dijk',
        card_type: 'yellow card',
        minute: '78'
      });
      tick();

      const updatedTimeline = result.timelineSignal();
      expect(updatedTimeline.length).toBe(initialCount + 1);

      const newCard = updatedTimeline.find(e => e.player === 'Van Dijk');
      expect(newCard?.type).toBe('YELLOW_CARD');
    }));

    it('should update status on MATCH_ENDED event', fakeAsync(() => {
      const liveMatchDto = { ...mockMatchDto, event_live: '1', event_status: '85' };
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(liveMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      expect(result.matchHeaderSignal().status.isLive).toBe(true);

      liveEventsSubject.next({
        match_id: '12345',
        type: 'MATCH_ENDED'
      });
      tick();

      expect(result.matchHeaderSignal().status.isLive).toBe(false);
      expect(result.matchHeaderSignal().status.status).toBe('FT');
    }));

    it('should update status on HALF_TIME event', fakeAsync(() => {
      const liveMatchDto = { ...mockMatchDto, event_live: '1', event_status: '45' };
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(liveMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      liveEventsSubject.next({
        match_id: '12345',
        type: 'HALF_TIME'
      });
      tick();

      expect(result.matchHeaderSignal().status.status).toBe('HT');
    }));

    it('should handle SUBSTITUTION event', fakeAsync(() => {
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      liveEventsSubject.next({
        match_id: '12345',
        type: 'SUBSTITUTION',
        team: 'home',
        player_in: 'Greenwood',
        player_out: 'Rashford',
        minute: '75'
      });
      tick();

      const timeline = result.timelineSignal();
      const sub = timeline.find(e => e.type === 'SUBSTITUTION' && e.player === 'Greenwood');
      expect(sub).toBeDefined();
      expect(sub?.detail).toContain('Rashford');
    }));

    it('should ignore events for different match', fakeAsync(() => {
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(mockMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      const initialScore = result.matchHeaderSignal().score;

      liveEventsSubject.next({
        match_id: 'different-match',
        type: 'GOAL_SCORED',
        team: 'home',
        scorer: 'Someone',
        minute: '50'
      });
      tick();

      // Score should remain unchanged
      expect(result.matchHeaderSignal().score).toEqual(initialScore);
    }));
  });

  describe('getEventStatus utility', () => {
    it('should return LIVE for live match', fakeAsync(() => {
      const liveMatchDto = { ...mockMatchDto, event_live: '1', event_status: '35' };
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(liveMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      expect(result.matchHeaderSignal().status.status).toBe('LIVE');
    }));

    it('should return HT for half time', fakeAsync(() => {
      const htMatchDto = { ...mockMatchDto, event_live: '1', event_status: 'Half Time' };
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(htMatchDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      expect(result.matchHeaderSignal().status.status).toBe('HT');
    }));

    it('should return FT for finished match', fakeAsync(() => {
      const finishedDto = { ...mockMatchDto, event_live: '0', event_status: 'Finished' };
      const matchIdSignal = signal<string | undefined>('12345');
      mockApiService.getMatch.and.returnValue(of(finishedDto));

      const result = TestBed.runInInjectionContext(() =>
        factory.create(matchIdSignal)
      );
      tick();

      expect(result.matchHeaderSignal().status.status).toBe('FT');
    }));
  });
});
