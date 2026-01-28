import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/providers/api_providers.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/signup_screen.dart';
import 'package:mobile/screens/forget_password_screen.dart';
import 'package:mobile/screens/mfa_setup_screen.dart';
import 'package:mobile/screens/email_verification_screen.dart';
import 'package:mobile/screens/notifications_screen.dart';
import 'package:mobile/screens/ranking_screen.dart';
import 'package:mobile/screens/diamond_store_screen.dart';
import 'package:mobile/screens/standings_screen.dart';
import 'package:mobile/screens/leagues_list_screen.dart';
import 'package:mobile/screens/match_detail_screen.dart';
import 'package:mobile/screens/team_detail_screen.dart';
import 'package:mobile/screens/error_screen.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/login', // Redirect to login for now
    ),
    // Auth routes
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/forget-password',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'];
        return ForgetPasswordScreen(token: token);
      },
    ),
    GoRoute(
      path: '/mfa-setup',
      builder: (context, state) => const MfaSetupScreen(),
    ),
    GoRoute(
      path: '/email-verification',
      builder: (context, state) => const EmailVerificationScreen(),
    ),
    // Other pages
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/ranking',
      builder: (context, state) => const RankingScreen(),
    ),
    GoRoute(
      path: '/diamond-store',
      builder: (context, state) => const DiamondStoreScreen(),
    ),
    // Standings routes
    GoRoute(
      path: '/standings',
      builder: (context, state) => const StandingsScreen(),
    ),
    GoRoute(
      path: '/leagues',
      builder: (context, state) => const LeaguesListScreen(),
    ),
    // Match and team details
    GoRoute(
      path: '/match/:matchId',
      builder: (context, state) =>
          MatchDetailScreen(matchId: state.pathParameters['matchId']!),
    ),
    GoRoute(
      path: '/team/:id',
      builder: (context, state) =>
          TeamDetailScreen(teamId: state.pathParameters['id']!),
    ),
    // Error routes
    GoRoute(path: '/error', builder: (context, state) => const ErrorScreen()),
    GoRoute(
      path: '/error/:errorCode',
      builder: (context, state) =>
          ErrorScreen(errorCode: state.pathParameters['errorCode']),
    ),
    // Home
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'KickStream Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () => context.go('/notifications'),
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Ranking'),
              onTap: () => context.go('/ranking'),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Diamond Store'),
              onTap: () => context.go('/diamond-store'),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Standings'),
              onTap: () => context.go('/standings'),
            ),
            ListTile(
              leading: const Icon(Icons.sports_soccer),
              title: const Text('Leagues'),
              onTap: () => context.go('/leagues'),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Welcome to KickStream!')),
    );
  }
}
