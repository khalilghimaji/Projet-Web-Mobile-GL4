import { Component, signal, OnInit, OnDestroy } from '@angular/core';
import { AsyncPipe, CommonModule, NgOptimizedImage } from '@angular/common';
import { RouterModule } from '@angular/router';
import { DrawerModule } from 'primeng/drawer';
import { AuthService } from '../../services/auth.service';
import { NotificationsApiService } from '../../services/notifications-api.service';
import { Notification } from '../../services/Api/model/notification';
import { Subscription } from 'rxjs';

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
  ],
  templateUrl: './side-menu.component.html',
  styleUrls: ['./side-menu.component.css'],
})
export class SideMenuComponent implements OnInit, OnDestroy {
  isMenuOpen = signal(false);

  topMenuItems: MenuItem[] = [];

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
      icon: 'pi pi-shield',
      label: 'Security Settings',
      route: '/mfa-setup',
    },
  ];

  diamonds = signal(0);
  private sseSubscription: Subscription | null = null;

  constructor(
    public authService: AuthService,
    private notificationsApi: NotificationsApiService
  ) {
    this.authService.currentUser$.subscribe((user) => {
      if (user && 'diamonds' in user) {
        this.diamonds.set(user.diamonds);
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
    this.sseSubscription = this.notificationsApi.connectToSSE().subscribe({
      next: (notification) => {
        if (notification.data?.newDiamonds)
          this.diamonds.set(notification.data?.newDiamonds);
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

  // Helper function to generate URL with cache-busting parameter
  getImageUrl(url: string): string {
    if (!url) return '/images/person.png';
    // Check if the URL is already absolute
    return url;
  }

  toggleMenu() {
    this.isMenuOpen.set(!this.isMenuOpen());
  }

  onLogout() {
    this.authService.logout();
    this.isMenuOpen.set(false);
  }
}
