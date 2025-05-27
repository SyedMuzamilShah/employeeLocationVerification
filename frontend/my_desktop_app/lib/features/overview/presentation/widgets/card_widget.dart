import 'package:flutter/material.dart';

class MyCardWidget extends StatelessWidget {
  final Widget child;
  const MyCardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            spreadRadius: 0.2,
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: child,
    );
  }
}