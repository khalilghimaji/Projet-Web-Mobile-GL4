import { TestBed } from '@angular/core/testing';
import { LeaguesService } from './leagues.service';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';

describe('LeaguesService', () => {
    let service: LeaguesService;

    beforeEach(() => {
        TestBed.configureTestingModule({
            providers: [
                LeaguesService,
                provideHttpClient(),
                provideHttpClientTesting()
            ]
        });
        service = TestBed.inject(LeaguesService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('leaguesResource', () => {
        it('should be defined and have expected methods', () => {
            TestBed.runInInjectionContext(() => {
                expect(service.leaguesResource).toBeDefined();
                expect(service.leaguesResource.value).toBeDefined();
                expect(service.leaguesResource.isLoading).toBeDefined();
                expect(service.leaguesResource.error).toBeDefined();
            });
        });

        it('should have a default value of empty array', () => {
            TestBed.runInInjectionContext(() => {
                const value = service.leaguesResource.value();
                expect(Array.isArray(value)).toBe(true);
            });
        });

        it('should have a reload method', () => {
            TestBed.runInInjectionContext(() => {
                expect(service.leaguesResource.reload).toBeDefined();
                expect(typeof service.leaguesResource.reload).toBe('function');
            });
        });
    });
});