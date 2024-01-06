import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UnderConstruction extends StatelessWidget {
  const UnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Lottie.asset('assets/underConstruction.json'),
      ),
    );
  }
}
