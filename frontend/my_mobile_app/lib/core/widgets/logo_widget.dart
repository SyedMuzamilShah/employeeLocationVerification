import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
              blurRadius: 2,
              // spreadRadius: 1,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/app_logo.png',
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.person, size: 40),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}