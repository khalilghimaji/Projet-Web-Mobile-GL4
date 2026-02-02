import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_drawer.dart';

class LeaguesListScreen extends StatelessWidget {
  const LeaguesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leagues')),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('Leagues List Screen - TODO: List leagues'),
      ),
    );
  }
}
