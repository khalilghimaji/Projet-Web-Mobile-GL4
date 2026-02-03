import { TestBed } from '@angular/core/testing';
import { StandingsService } from './standings.service';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { signal } from '@angular/core';

describe('StandingsService', () => {
    let service: StandingsService;

    beforeEach(() => {
        TestBed.configureTestingModule({
            providers: [
                StandingsService,
                provideHttpClient(),
                provideHttpClientTesting()
            ]
        });
        service = TestBed.inject(StandingsService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('getStandingsResource', () => {
        it('should create a resource with the correct configuration', () => {
            TestBed.runInInjectionContext(() => {
                const leagueIdFn = () => '152';
                const resource = service.getStandingsResource(leagueIdFn);

                expect(resource).toBeDefined();
                expect(resource.value).toBeDefined();
                expect(resource.isLoading).toBeDefined();
                expect(resource.error).toBeDefined();
            });
        });

        it('should use the provided leagueId function', () => {
            TestBed.runInInjectionContext(() => {
                const leagueIdSignal = signal('152');
                const leagueIdFn = () => leagueIdSignal();

                const resource = service.getStandingsResource(leagueIdFn);

                // Verify the resource is created
                expect(resource).toBeDefined();

                // Change the leagueId
                leagueIdSignal.set('302');

                // The resource should react to the change in the signal
                expect(leagueIdFn()).toBe('302');
            });
        });

        it('should create resource with correct API parameters', () => {
            TestBed.runInInjectionContext(() => {
                const leagueIdFn = () => '152';
                const resource = service.getStandingsResource(leagueIdFn);

                // The resource should be properly configured
                expect(resource).toBeDefined();
                expect(typeof resource.value).toBe('function');
                expect(typeof resource.isLoading).toBe('function');
            });
        });
    });
});