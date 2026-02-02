import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_drawer.dart';

class MatchDetailScreen extends StatelessWidget {
  final String matchId;

  const MatchDetailScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Match $matchId')),
      drawer: const AppDrawer(),
      body: Center(
        child: Text('Match Detail Screen for ID: $matchId - TODO: Implement'),
      ),
    );
  }
}
