import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_drawer.dart';

class TeamDetailScreen extends StatelessWidget {
  final String teamId;

  const TeamDetailScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team $teamId')),
      drawer: const AppDrawer(),
      body: Center(
        child: Text('Team Detail Screen for ID: $teamId - TODO: Implement'),
      ),
    );
  }
}
