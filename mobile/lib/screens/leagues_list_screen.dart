import 'package:flutter/material.dart';

class LeaguesListScreen extends StatelessWidget {
  const LeaguesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leagues')),
      body: const Center(
        child: Text('Leagues List Screen - TODO: List leagues'),
      ),
    );
  }
}
