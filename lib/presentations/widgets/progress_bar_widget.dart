import 'package:flutter/material.dart';

final class ProgressBar extends StatelessWidget {
  final Color? color;

  const ProgressBar({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // * Empty Progress Indicator
          CircularProgressIndicator(
              value: 100, color: Colors.white, backgroundColor: color),
          // * Progress Indicator
          CircularProgressIndicator(backgroundColor: color),
        ],
      ),
    );
  }
}
