import 'package:flutter/material.dart';

class CircularProgressIcon extends StatelessWidget {
  const CircularProgressIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16,
      width: 16,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
