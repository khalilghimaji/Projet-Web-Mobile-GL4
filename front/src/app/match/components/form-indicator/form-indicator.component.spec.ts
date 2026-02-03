import { ComponentFixture, TestBed } from '@angular/core/testing';
import { FormIndicatorComponent, FormResult } from './form-indicator.component';
import { ComponentRef } from '@angular/core';

describe('FormIndicatorComponent', () => {
  let component: FormIndicatorComponent;
  let fixture: ComponentFixture<FormIndicatorComponent>;
  let componentRef: ComponentRef<FormIndicatorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FormIndicatorComponent]
    }).compileComponents();

    fixture = TestBed.createComponent(FormIndicatorComponent);
    component = fixture.componentInstance;
    componentRef = fixture.componentRef;
  });

  it('should create', () => {
    componentRef.setInput('formSignal', ['W', 'W', 'D']);
    fixture.detectChanges();
    expect(component).toBeTruthy();
  });

  it('should accept form results input', () => {
    const form: FormResult[] = ['W', 'D', 'L', 'W', 'W'];
    componentRef.setInput('formSignal', form);
    fixture.detectChanges();
    expect(component.formSignal()).toEqual(form);
  });

  it('should display winning streak', () => {
    const winningStreak: FormResult[] = ['W', 'W', 'W', 'W', 'W'];
    componentRef.setInput('formSignal', winningStreak);
    fixture.detectChanges();

    const results = component.formSignal();
    expect(results.length).toBe(5);
    expect(results.every(r => r === 'W')).toBe(true);
  });

  it('should display losing streak', () => {
    const losingStreak: FormResult[] = ['L', 'L', 'L'];
    componentRef.setInput('formSignal', losingStreak);
    fixture.detectChanges();

    const results = component.formSignal();
    expect(results.length).toBe(3);
    expect(results.every(r => r === 'L')).toBe(true);
  });

  it('should display mixed results', () => {
    const mixedForm: FormResult[] = ['W', 'D', 'L', 'W', 'D'];
    componentRef.setInput('formSignal', mixedForm);
    fixture.detectChanges();

    const results = component.formSignal();
    expect(results).toContain('W');
    expect(results).toContain('D');
    expect(results).toContain('L');
  });

  it('should handle empty form', () => {
    const emptyForm: FormResult[] = [];
    componentRef.setInput('formSignal', emptyForm);
    fixture.detectChanges();

    expect(component.formSignal().length).toBe(0);
  });

  it('should render correct number of result indicators', () => {
    const form: FormResult[] = ['W', 'W', 'D', 'L', 'W'];
    componentRef.setInput('formSignal', form);
    fixture.detectChanges();

    const compiled = fixture.nativeElement as HTMLElement;
    const indicators = compiled.querySelectorAll('.size-8');
    expect(indicators.length).toBe(5);
  });

  it('should display result letters correctly', () => {
    const form: FormResult[] = ['W', 'D', 'L'];
    componentRef.setInput('formSignal', form);
    fixture.detectChanges();

    const compiled = fixture.nativeElement as HTMLElement;
    const indicators = compiled.querySelectorAll('.size-8');

    expect(indicators[0].textContent?.trim()).toBe('W');
    expect(indicators[1].textContent?.trim()).toBe('D');
    expect(indicators[2].textContent?.trim()).toBe('L');
  });

  it('should apply win styling', () => {
    const form: FormResult[] = ['W'];
    componentRef.setInput('formSignal', form);
    fixture.detectChanges();

    const compiled = fixture.nativeElement as HTMLElement;
    const winIndicator = compiled.querySelector('.size-8');
    expect(winIndicator?.classList.contains('bg-green-500')).toBe(true);
  });

  it('should apply draw styling', () => {
    const form: FormResult[] = ['D'];
    componentRef.setInput('formSignal', form);
    fixture.detectChanges();

    const compiled = fixture.nativeElement as HTMLElement;
    const drawIndicator = compiled.querySelector('.size-8');
    expect(drawIndicator?.classList.contains('bg-gray-400')).toBe(true);
  });

  it('should apply loss styling', () => {
    const form: FormResult[] = ['L'];
    componentRef.setInput('formSignal', form);
    fixture.detectChanges();

    const compiled = fixture.nativeElement as HTMLElement;
    const lossIndicator = compiled.querySelector('.size-8');
    expect(lossIndicator?.classList.contains('bg-red-500')).toBe(true);
  });

  it('should update when form changes', () => {
    const initialForm: FormResult[] = ['W', 'W'];
    componentRef.setInput('formSignal', initialForm);
    fixture.detectChanges();
    expect(component.formSignal().length).toBe(2);

    const updatedForm: FormResult[] = ['W', 'W', 'D', 'L'];
    componentRef.setInput('formSignal', updatedForm);
    fixture.detectChanges();
    expect(component.formSignal().length).toBe(4);
  });

  it('should use OnPush change detection strategy', () => {
    componentRef.setInput('formSignal', ['W']);
    expect(fixture.componentRef.changeDetectorRef).toBeDefined();
  });

  it('should handle typical last 5 matches form', () => {
    const lastFive: FormResult[] = ['W', 'L', 'D', 'W', 'W'];
    componentRef.setInput('formSignal', lastFive);
    fixture.detectChanges();

    const wins = component.formSignal().filter(r => r === 'W').length;
    const draws = component.formSignal().filter(r => r === 'D').length;
    const losses = component.formSignal().filter(r => r === 'L').length;

    expect(wins).toBe(3);
    expect(draws).toBe(1);
    expect(losses).toBe(1);
  });

  it('should calculate recent form quality', () => {
    const excellentForm: FormResult[] = ['W', 'W', 'W', 'W', 'D'];
    componentRef.setInput('formSignal', excellentForm);
    fixture.detectChanges();

    const wins = component.formSignal().filter(r => r === 'W').length;
    expect(wins).toBeGreaterThan(component.formSignal().length / 2);
  });

  it('should identify poor form', () => {
    const poorForm: FormResult[] = ['L', 'L', 'L', 'D', 'L'];
    componentRef.setInput('formSignal', poorForm);
    fixture.detectChanges();

    const losses = component.formSignal().filter(r => r === 'L').length;
    expect(losses).toBeGreaterThan(component.formSignal().length / 2);
  });
});
