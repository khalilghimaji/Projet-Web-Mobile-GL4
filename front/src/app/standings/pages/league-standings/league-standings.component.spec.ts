import { ComponentFixture, TestBed } from '@angular/core/testing';
import { LeagueStandingsComponent } from './league-standings.component';
import { Router } from '@angular/router';
import { StandingsService } from '../../services/standings.service';
import { StandingsResponse, StandingEntry } from '../../../teams/models/models';
import { ComponentFixtureAutoDetect } from '@angular/core/testing';

describe('LeagueStandingsComponent', () => {
  let component: LeagueStandingsComponent;
  let fixture: ComponentFixture<LeagueStandingsComponent>;
  let mockRouter: jasmine.SpyObj<Router>;
  let mockStandingsService: jasmine.SpyObj<StandingsService>;

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
    mockRouter = jasmine.createSpyObj('Router', ['navigate']);
    mockStandingsService = jasmine.createSpyObj('StandingsService', ['getStandingsResource']);

    // Mock the resource object returned by getStandingsResource
    const mockResource = {
      value: jasmine.createSpy('value').and.returnValue(mockStandingsResponse),
      isLoading: jasmine.createSpy('isLoading').and.returnValue(false),
      error: jasmine.createSpy('error').and.returnValue(undefined),
      reload: jasmine.createSpy('reload'),
      hasValue: jasmine.createSpy('hasValue').and.returnValue(true)
    };

    mockStandingsService.getStandingsResource.and.returnValue(mockResource as any);

    await TestBed.configureTestingModule({
      imports: [LeagueStandingsComponent],
      providers: [
        { provide: Router, useValue: mockRouter },
        { provide: StandingsService, useValue: mockStandingsService },
        { provide: ComponentFixtureAutoDetect, useValue: true }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(LeagueStandingsComponent);
    component = fixture.componentInstance;

    // Set required input
    fixture.componentRef.setInput('leagueId', '152');
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  describe('initialization', () => {
    it('should initialize with required leagueId input', () => {
      expect(component.leagueId()).toBe('152');
    });

    it('should call getStandingsResource with leagueId', () => {
      fixture.detectChanges();
      expect(mockStandingsService.getStandingsResource).toHaveBeenCalled();
    });

    it('should initialize selectedView as total', () => {
      expect(component.selectedView()).toBe('total');
    });
  });

  describe('currentStandings computed', () => {
    it('should return total standings by default', () => {
      const standings = component.currentStandings();
      expect(standings).toEqual(mockStandingsResponse.result.total);
    });

    it('should return home standings when selectedView is home', () => {
      component.selectedView.set('home');
      const standings = component.currentStandings();
      expect(standings).toEqual(mockStandingsResponse.result.home);
    });

    it('should return away standings when selectedView is away', () => {
      component.selectedView.set('away');
      const standings = component.currentStandings();
      expect(standings).toEqual(mockStandingsResponse.result.away);
    });

    it('should return empty array when no data', () => {
      const mockEmptyResource = {
        value: jasmine.createSpy('value').and.returnValue(null),
        isLoading: jasmine.createSpy('isLoading').and.returnValue(false),
        error: jasmine.createSpy('error').and.returnValue(undefined),
        reload: jasmine.createSpy('reload'),
        hasValue: jasmine.createSpy('hasValue').and.returnValue(false)
      };

      mockStandingsService.getStandingsResource.and.returnValue(mockEmptyResource as any);

      // Create new component with empty resource
      const newFixture = TestBed.createComponent(LeagueStandingsComponent);
      const newComponent = newFixture.componentInstance;
      newFixture.componentRef.setInput('leagueId', '152');

      expect(newComponent.currentStandings()).toEqual([]);
    });
  });

  describe('setView', () => {
    it('should change selected view to home', () => {
      component.setView('home');
      expect(component.selectedView()).toBe('home');
    });

    it('should change selected view to away', () => {
      component.setView('away');
      expect(component.selectedView()).toBe('away');
    });

    it('should change selected view to total', () => {
      component.setView('total');
      expect(component.selectedView()).toBe('total');
    });
  });

  describe('backToLeagues', () => {
    it('should navigate back to standings page', () => {
      component.backToLeagues();
      expect(mockRouter.navigate).toHaveBeenCalledWith(['/standings']);
    });
  });

  describe('goToTeam', () => {
    it('should navigate to team detail page', () => {
      component.goToTeam('123');
      expect(mockRouter.navigate).toHaveBeenCalledWith(['/team', '123']);
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
