import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:mobile/providers/api_providers.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      drawer: const AppDrawer(),
      body: const Center(child: Text('Welcome to KickStream!')),
    );
  }
}
