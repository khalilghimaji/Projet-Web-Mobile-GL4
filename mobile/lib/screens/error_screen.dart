import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_drawer.dart';

class ErrorScreen extends StatelessWidget {
  final String? errorCode;

  const ErrorScreen({super.key, this.errorCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      drawer: const AppDrawer(),
      body: Center(
        child: Text('Error ${errorCode ?? ''} - Something went wrong'),
      ),
    );
  }
}
