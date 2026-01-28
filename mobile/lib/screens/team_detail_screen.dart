import 'package:flutter/material.dart';

class TeamDetailScreen extends StatelessWidget {
  final String teamId;

  const TeamDetailScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team $teamId')),
      body: Center(
        child: Text('Team Detail Screen for ID: $teamId - TODO: Implement'),
      ),
    );
  }
}
