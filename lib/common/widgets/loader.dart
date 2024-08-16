import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: NutsActivityIndicator(
        activeColor: Colors.grey,
        inactiveColor: Colors.lightGreen,
        radius: 30,
      ),
    );
  }
}
