import 'package:flutter/material.dart';

class MatchDetailScreen extends StatelessWidget {
  final String matchId;

  const MatchDetailScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Match $matchId')),
      body: Center(
        child: Text('Match Detail Screen for ID: $matchId - TODO: Implement'),
      ),
    );
  }
}
