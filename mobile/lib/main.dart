import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:mobile/services/realtime_updates_service.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch authentication state and update realtime service
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      final realtimeService = ref.read(realtimeUpdatesServiceProvider);
      realtimeService.updateAuthenticationStatus(next);
    });

    return MaterialApp.router(
      routerConfig: _router,
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

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        // This will be handled by a redirect based on auth state
        // For now, default to login
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
      body: const Center(child: Text('Welcome to KickStream!')),
    );
  }
}
