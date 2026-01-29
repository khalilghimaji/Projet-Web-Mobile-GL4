import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:mobile/services/realtime_updates_service.dart';
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/providers/notifications_provider.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/signup_screen.dart';
import 'package:mobile/screens/notifications_screen.dart';
import 'package:mobile/screens/ranking_screen.dart';
import 'package:mobile/screens/diamond_store_screen.dart';
import 'package:mobile/screens/standings_screen.dart';
import 'package:mobile/screens/leagues_list_screen.dart';
import 'package:mobile/screens/match_detail_screen.dart';
import 'package:mobile/screens/team_detail_screen.dart';
import 'package:mobile/screens/error_screen.dart';
import 'package:mobile/widgets/app_drawer.dart';

// Static router instance
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        // This will be handled by initial navigation logic
        return '/login';
      },
    ),
    // Auth routes
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    // Protected routes
    GoRoute(
      path: '/notifications',
      builder: (context, state) =>
          const AuthGuard(child: NotificationsScreen()),
    ),
    GoRoute(
      path: '/ranking',
      builder: (context, state) => const AuthGuard(child: RankingScreen()),
    ),
    GoRoute(
      path: '/diamond-store',
      builder: (context, state) => const AuthGuard(child: DiamondStoreScreen()),
    ),
    // Standings routes
    GoRoute(
      path: '/standings',
      builder: (context, state) => const AuthGuard(child: StandingsScreen()),
    ),
    GoRoute(
      path: '/leagues',
      builder: (context, state) => const AuthGuard(child: LeaguesListScreen()),
    ),
    // Match and team details
    GoRoute(
      path: '/match/:matchId',
      builder: (context, state) => AuthGuard(
        child: MatchDetailScreen(matchId: state.pathParameters['matchId']!),
      ),
    ),
    GoRoute(
      path: '/team/:id',
      builder: (context, state) => AuthGuard(
        child: TeamDetailScreen(teamId: state.pathParameters['id']!),
      ),
    ),
    // Error routes
    GoRoute(path: '/error', builder: (context, state) => const ErrorScreen()),
    GoRoute(
      path: '/error/:errorCode',
      builder: (context, state) =>
          ErrorScreen(errorCode: state.pathParameters['errorCode']),
    ),
    // Home
    GoRoute(
      path: '/home',
      builder: (context, state) => const AuthGuard(child: HomeScreen()),
    ),
    // Catch all
    GoRoute(path: '/:path', redirect: (context, state) => '/error/404'),
  ],
);

// Router provider that returns the static router
final routerProvider = Provider<GoRouter>((ref) {
  return _router;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  await NotificationService().initialize();

  // Initialize profile loading
  final container = ProviderContainer();
  await _initializeProfile(container);

  runApp(
    UncontrolledProviderScope(container: container, child: const MainApp()),
  );
}

Future<void> _initializeProfile(ProviderContainer container) async {
  try {
    print('[APP] Attempting to load user profile on app start...');

    // Try to load user profile
    final authApi = container.read(authenticationApiProvider);
    final response = await authApi.authControllerGetProfile();

    if (response.statusCode == 200 && response.data != null) {
      // Set user data
      await container.read(userDataProvider.notifier).setUser(response.data!);
      print('[APP] Profile loaded successfully, user authenticated');
    } else {
      print('[APP] Profile load failed with status: ${response.statusCode}');
      // Clear any invalid tokens
      await container.read(accessTokenProvider.notifier).clearToken();
      await container.read(refreshTokenProvider.notifier).clearToken();
      await container.read(userDataProvider.notifier).clearUser();
    }
  } catch (error) {
    print('[APP] Profile load error: $error');
    // Clear any invalid tokens on error
    await container.read(accessTokenProvider.notifier).clearToken();
    await container.read(refreshTokenProvider.notifier).clearToken();
    await container.read(userDataProvider.notifier).clearUser();
  }

  // Handle initial navigation after profile check
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final authState = container.read(authStateProvider);
    if (authState.isAuthenticated) {
      _router.go('/home');
    } else {
      _router.go('/login');
    }
  });
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Set router for notification service
    NotificationService.setRouter(router);

    // Watch authentication state and update realtime service
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      final realtimeService = ref.read(realtimeUpdatesServiceProvider);
      realtimeService.updateAuthenticationStatus(next);

      // Load notifications when user becomes authenticated
      if (next.isAuthenticated &&
          (previous == null || !previous.isAuthenticated)) {
        final notificationsState = ref.read(notificationsProvider);
        print(
          '[APP] User authenticated, checking notification state: loading=${notificationsState.isLoading}, count=${notificationsState.notifications.length}',
        );
        // Reset any stuck loading state first
        if (notificationsState.isLoading) {
          print('[APP] Resetting stuck loading state');
          ref.read(notificationsProvider.notifier).resetLoadingState();
        }
        // Only load if not already loading and no notifications loaded yet
        if (!notificationsState.isLoading &&
            notificationsState.notifications.isEmpty) {
          print('[APP] Loading notifications on app start...');
          ref.read(notificationsProvider.notifier).loadNotifications();
        } else {
          print(
            '[APP] Skipping notification load: loading=${notificationsState.isLoading}, hasData=${notificationsState.notifications.isNotEmpty}',
          );
        }
      }
    });

    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}

class AuthGuard extends ConsumerWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (!authState.isAuthenticated) {
      // If not authenticated, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return child;
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KickStream Mobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authActionsProvider).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to KickStream!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                NotificationService().showTestNotification();
              },
              child: const Text('Test Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
