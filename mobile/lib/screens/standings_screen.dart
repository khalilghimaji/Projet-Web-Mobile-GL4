import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_drawer.dart';

class StandingsScreen extends StatelessWidget {
  final String? leagueId;

  const StandingsScreen({super.key, this.leagueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Standings')),
      drawer: const AppDrawer(),
      body: Center(
        child: Text(leagueId != null
            ? 'Standings for League: $leagueId - TODO: League standings'
            : 'Standings Screen - TODO: League standings'),
      ),
    );
  }
}
