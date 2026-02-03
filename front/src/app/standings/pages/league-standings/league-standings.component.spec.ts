import { ComponentFixture, TestBed } from '@angular/core/testing';
import { LeagueStandingsComponent } from './league-standings.component';
import { ActivatedRoute, Router } from '@angular/router';
import { StandingsService } from '../../services/standings.service';
import { StandingsUpdaterService } from '../../services/goal-events.service';
import { LeaguesService } from '../../services/leagues.service';
import { of, throwError } from 'rxjs';
import { League, StandingsResponse, StandingEntry } from '../../models/models';
import { ChangeDetectorRef } from '@angular/core';

describe('LeagueStandingsComponent', () => {
  let component: LeagueStandingsComponent;
  let fixture: ComponentFixture<LeagueStandingsComponent>;
  let mockActivatedRoute: any;
  let mockRouter: jasmine.SpyObj<Router>;
  let mockStandingsService: jasmine.SpyObj<StandingsService>;
  let mockStandingsUpdater: jasmine.SpyObj<StandingsUpdaterService>;
  let mockLeaguesService: jasmine.SpyObj<LeaguesService>;

  const mockLeague: League = {
    league_key: '152',
    league_name: 'Premier League',
    country_key: '44',
    country_name: 'England',
    league_logo: 'pl.png',
    country_logo: 'england.png'
  };

  const mockStanding: StandingEntry = {
    standing_place: '1',
    standing_place_type: 'Champions League',
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
      total: [mockStanding],
      home: [mockStanding],
      away: [mockStanding]
    }
  };

  beforeEach(async () => {
    mockActivatedRoute = {
      snapshot: {
        paramMap: {
          get: jasmine.createSpy('get').and.returnValue(null)
        }
      }
    };

    mockRouter = jasmine.createSpyObj('Router', ['navigate']);
    mockStandingsService = jasmine.createSpyObj('StandingsService', ['getCachedStandings']);
    mockStandingsUpdater = jasmine.createSpyObj('StandingsUpdaterService', [
      'startListening',
      'stopListening'
    ]);
    mockLeaguesService = jasmine.createSpyObj('LeaguesService', ['getFeaturedLeagues']);

    await TestBed.configureTestingModule({
      imports: [LeagueStandingsComponent],
      providers: [
        { provide: ActivatedRoute, useValue: mockActivatedRoute },
        { provide: Router, useValue: mockRouter },
        { provide: StandingsService, useValue: mockStandingsService },
        { provide: StandingsUpdaterService, useValue: mockStandingsUpdater },
        { provide: LeaguesService, useValue: mockLeaguesService }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(LeagueStandingsComponent);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  describe('ngOnInit with league selection', () => {
    it('should load leagues when no leagueId is provided', () => {
      mockLeaguesService.getFeaturedLeagues.and.returnValue(of([mockLeague]));

      fixture.detectChanges(); // Triggers ngOnInit

      expect(component.showLeagueSelection).toBe(true);
      expect(mockLeaguesService.getFeaturedLeagues).toHaveBeenCalled();
      expect(component.leagues.length).toBe(1);
      expect(component.loading).toBe(false);
    });

    it('should handle error when loading leagues', () => {
      mockLeaguesService.getFeaturedLeagues.and.returnValue(
        throwError(() => new Error('Network error'))
      );

      fixture.detectChanges();

      expect(component.error).toBe('Failed to load leagues. Please try again later.');
      expect(component.loading).toBe(false);
    });
  });

  describe('ngOnInit with specific league', () => {
    it('should load standings when leagueId is in route', () => {
      mockActivatedRoute.snapshot.paramMap.get.and.returnValue('152');
      mockStandingsService.getCachedStandings.and.returnValue(of(mockStandingsResponse));

      fixture.detectChanges();

      expect(component.showLeagueSelection).toBe(false);
      expect(mockStandingsUpdater.startListening).toHaveBeenCalled();
      expect(mockStandingsService.getCachedStandings).toHaveBeenCalledWith('152');
      expect(component.standings).toEqual(mockStandingsResponse);
    });

    it('should load standings when leagueId is provided as Input', () => {
      component.leagueId = '302';
      mockStandingsService.getCachedStandings.and.returnValue(of(mockStandingsResponse));

      fixture.detectChanges();

      expect(mockStandingsService.getCachedStandings).toHaveBeenCalledWith('302');
      expect(component.loading).toBe(false);
    });

    it('should handle error when loading standings', () => {
      mockActivatedRoute.snapshot.paramMap.get.and.returnValue('152');
      mockStandingsService.getCachedStandings.and.returnValue(
        throwError(() => new Error('Network error'))
      );

      fixture.detectChanges();

      expect(component.error).toBe('Failed to load standings. Please try again later.');
      expect(component.loading).toBe(false);
    });
  });

  describe('ngOnDestroy', () => {
    it('should unsubscribe and stop listening on destroy', () => {
      mockActivatedRoute.snapshot.paramMap.get.and.returnValue('152');
      mockStandingsService.getCachedStandings.and.returnValue(of(mockStandingsResponse));

      fixture.detectChanges();
      component.ngOnDestroy();

      expect(mockStandingsUpdater.stopListening).toHaveBeenCalled();
    });
  });

  describe('selectLeague', () => {
    it('should navigate to league standings', () => {
      component.selectLeague(mockLeague);

      expect(component.selectedLeague).toEqual(mockLeague);
      expect(mockRouter.navigate).toHaveBeenCalledWith(['/standings', '152']);
    });
  });

  describe('backToLeagues', () => {
    it('should navigate back to standings page', () => {
      component.backToLeagues();

      expect(mockRouter.navigate).toHaveBeenCalledWith(['/standings']);
    });
  });

  describe('currentStandings getter', () => {
    beforeEach(() => {
      component.standings = mockStandingsResponse;
    });

    it('should return total standings by default', () => {
      component.selectedView = 'total';
      expect(component.currentStandings).toEqual(mockStandingsResponse.result.total);
    });

    it('should return home standings when selected', () => {
      component.selectedView = 'home';
      expect(component.currentStandings).toEqual(mockStandingsResponse.result.home);
    });

    it('should return away standings when selected', () => {
      component.selectedView = 'away';
      expect(component.currentStandings).toEqual(mockStandingsResponse.result.away);
    });

    it('should return empty array when no standings', () => {
      component.standings = null;
      expect(component.currentStandings).toEqual([]);
    });
  });

  describe('setView', () => {
    it('should change selected view', () => {
      component.setView('home');
      expect(component.selectedView).toBe('home');

      component.setView('away');
      expect(component.selectedView).toBe('away');

      component.setView('total');
      expect(component.selectedView).toBe('total');
    });
  });

  describe('getPlaceTypeClass', () => {
    it('should return champions-league class', () => {
      expect(component.getPlaceTypeClass('Champions League')).toBe('champions-league');
    });

    it('should return europa-league class', () => {
      expect(component.getPlaceTypeClass('Europa League')).toBe('europa-league');
    });

    it('should return relegation class', () => {
      expect(component.getPlaceTypeClass('Relegation')).toBe('relegation');
    });

    it('should return empty string for null', () => {
      expect(component.getPlaceTypeClass(null)).toBe('');
    });

    it('should return empty string for unknown type', () => {
      expect(component.getPlaceTypeClass('Unknown')).toBe('');
    });
  });

  describe('isPositive and isNegative', () => {
    it('should detect positive values', () => {
      expect(component.isPositive('5')).toBe(true);
      expect(component.isPositive('0')).toBe(false);
      expect(component.isPositive('-5')).toBe(false);
    });

    it('should detect negative values', () => {
      expect(component.isNegative('-5')).toBe(true);
      expect(component.isNegative('0')).toBe(false);
      expect(component.isNegative('5')).toBe(false);
    });
  });
});
