import 'package:flutter/material.dart';

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Standings')),
      body: const Center(
        child: Text('Standings Screen - TODO: League standings'),
      ),
    );
  }
}
