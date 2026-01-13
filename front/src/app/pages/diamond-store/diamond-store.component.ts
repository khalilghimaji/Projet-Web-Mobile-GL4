import {
  ChangeDetectionStrategy,
  Component,
  inject,
  signal,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { ButtonModule } from 'primeng/button';
import { CardModule } from 'primeng/card';
import { MatchesService } from '../../services/Api';
import { NotificationService } from '../../services/notification.service';

interface DiamondPackage {
  id: number;
  amount: number;
  price: string;
  popular?: boolean;
  icon: string;
}

@Component({
  selector: 'app-diamond-store',
  standalone: true,
  imports: [CommonModule, ButtonModule, CardModule],
  templateUrl: './diamond-store.component.html',
  styleUrls: ['./diamond-store.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class DiamondStoreComponent {
  private readonly matchesService = inject(MatchesService);
  private readonly notificationService = inject(NotificationService);

  loading = signal<{ [key: number]: boolean }>({});

  diamondPackages: DiamondPackage[] = [
    {
      id: 1,
      amount: 10,
      price: '$0.99',
      icon: '💎',
    },
    {
      id: 2,
      amount: 50,
      price: '$4.99',
      icon: '💎💎',
    },
    {
      id: 3,
      amount: 100,
      price: '$8.99',
      popular: true,
      icon: '💎💎💎',
    },
    {
      id: 4,
      amount: 250,
      price: '$19.99',
      icon: '💎💎💎💎',
    },
    {
      id: 5,
      amount: 500,
      price: '$34.99',
      icon: '💎💎💎💎💎',
    },
    {
      id: 6,
      amount: 1000,
      price: '$59.99',
      icon: '💎💎💎💎💎💎',
    },
  ];

  purchaseDiamonds(pkg: DiamondPackage): void {
    this.loading.update((loading) => ({ ...loading, [pkg.id]: true }));

    this.matchesService
      .matchesControllerAddDiamond({
        numberOfDiamondsBet: pkg.amount,
      })
      .subscribe({
        next: () => {
          this.notificationService.showSuccess(
            `Successfully purchased ${pkg.amount} diamonds!`
          );
          this.loading.update((loading) => ({ ...loading, [pkg.id]: false }));
        },
        error: (error) => {
          console.error('Error purchasing diamonds:', error);
          this.notificationService.showError(
            'Failed to purchase diamonds. Please try again.'
          );
          this.loading.update((loading) => ({ ...loading, [pkg.id]: false }));
        },
      });
  }

  isLoading(packageId: number): boolean {
    return this.loading()[packageId] || false;
  }
}
