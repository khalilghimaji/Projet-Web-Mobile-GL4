import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/api_providers.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
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
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              context.go('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              context.go('/notifications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Ranking'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              context.go('/ranking');
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Diamond Store'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              context.go('/diamond-store');
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Standings'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              context.go('/standings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text('Leagues'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              context.go('/leagues');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.of(context).pop(); // Close drawer
              await ref.read(authActionsProvider).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
