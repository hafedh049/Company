import 'package:flutter/material.dart';

class FError extends StatelessWidget {
  const FError({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error),
      ),
    );
  }
}
