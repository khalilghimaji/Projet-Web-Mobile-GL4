import { Component, signal, OnInit, OnDestroy } from '@angular/core';
import { AsyncPipe, CommonModule, NgOptimizedImage } from '@angular/common';
import { RouterModule } from '@angular/router';
import { DrawerModule } from 'primeng/drawer';
import { AuthService } from '../../services/auth.service';
import { NotificationsApiService } from '../../services/notifications-api.service';
import { filter, Subscription } from 'rxjs';
import { ImageDefaultPipe } from '../../shared/pipes/image-default.pipe';

interface MenuItem {
  icon: string;
  label: string;
  route?: string;
  active?: boolean;
  badge?: number;
  hasChildren?: boolean;
  children?: MenuItem[];
}

@Component({
  selector: 'app-side-menu',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    NgOptimizedImage,
    DrawerModule,
    AsyncPipe,
    ImageDefaultPipe,
  ],
  templateUrl: './side-menu.component.html',
  styleUrls: ['./side-menu.component.css'],
})
export class SideMenuComponent implements OnInit, OnDestroy {
  isMenuOpen = signal(false);

  topMenuItems: MenuItem[] = [
    {
      icon: 'pi pi-calendar',
      label: 'Fixtures',
      route: '/fixtures',
    },
    {
      icon: 'pi pi-chart-bar',
      label: 'Standings',
      route: '/standings',
    },
  ];

  authMenuItems: MenuItem[] = [
    {
      icon: 'pi pi-user',
      label: 'Login',
      route: '/login',
    },
    {
      icon: 'pi pi-user-plus',
      label: 'Sign Up',
      route: '/signup',
    },
    {
      icon: 'pi pi-lock',
      label: 'Forgot Password',
      route: '/forget-password',
    },
  ];

  bottomMenuItems: MenuItem[] = [
    {
      icon: 'pi pi-bell',
      label: 'Notifications',
      route: '/notifications',
    },
    {
      icon: 'pi pi-crown',
      label: 'Diamond Store',
      route: '/diamond-store',
    },
    {
      icon: 'pi pi-shield',
      label: 'Security Settings',
      route: '/mfa-setup',
    },
  ];

  diamonds = signal(0);
  gainedDiamonds = signal(0);
  private sseSubscription: Subscription | null = null;

  constructor(
    public authService: AuthService,
    private notificationsApi: NotificationsApiService
  ) {
    this.authService.currentUser$.subscribe((user) => {
      console.log('User updated in SideMenuComponent:', user);
      if (user && 'diamonds' in user) {
        this.diamonds.set(user.diamonds ?? 0);
      }
    });
  }

  ngOnInit(): void {
    this.connectToSSE();
  }

  ngOnDestroy(): void {
    this.disconnectSSE();
  }

  private connectToSSE(): void {
    this.sseSubscription = this.notificationsApi
      .connectToSSE()
      .pipe(
        filter(
          (event) =>
            event.type === 'CHANGE_OF_POSSESSED_GEMS' ||
            event.type === 'DIAMOND_UPDATE'
        )
      )
      .subscribe({
        next: (notification) => {
          if (
            notification.type === 'CHANGE_OF_POSSESSED_GEMS' &&
            notification.data?.newDiamonds
          ) {
            this.diamonds.set(notification.data?.newDiamonds);
          }
          if (notification.type === 'DIAMOND_UPDATE') {
            this.gainedDiamonds.set(notification.data?.gain || 0);
          }
        },
        error: (error) => {
          console.error('SSE error:', error);
        },
      });
  }
  get isAuthenticated() {
    return this.authService.authState$;
  }
  private disconnectSSE(): void {
    if (this.sseSubscription) {
      this.sseSubscription.unsubscribe();
    }
    this.notificationsApi.disconnectSSE();
  }

  toggleMenu() {
    this.isMenuOpen.set(!this.isMenuOpen());
  }

  onLogout() {
    this.authService.logout();
    this.isMenuOpen.set(false);
  }
}
