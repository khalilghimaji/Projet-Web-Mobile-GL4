import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String? errorCode;

  const ErrorScreen({super.key, this.errorCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Error ${errorCode ?? ''} - Something went wrong'),
      ),
    );
  }
}
