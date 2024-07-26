import 'package:company/utils/shared.dart';
import 'package:flutter/material.dart';

class Wait extends StatelessWidget {
  const Wait({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator(color: lightGreen)));
  }
}
