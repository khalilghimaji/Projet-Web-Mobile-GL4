import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_drawer.dart';

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Standings')),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('Standings Screen - TODO: League standings'),
      ),
    );
  }
}
