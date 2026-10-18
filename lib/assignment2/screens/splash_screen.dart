import 'package:flutter/material.dart';

import '../theme/a2_theme.dart';

// ============================================================
// SplashScreen — the first screen of Rabbit Track (static).
//
// Shows the logo (asset image), the app name and a loading
// indicator. No navigation yet — Assignment 3 connects it.
// ============================================================
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App logo — asset image registered in pubspec.yaml.
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // App name and tagline.
          const Text(
            'Rabbit Track',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: A2Colors.primaryDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Professional Rabbit Farm Management',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: A2Colors.textGrey),
            ),
          ),
          const SizedBox(height: 48),

          // Simple loading indicator (look only).
          const CircularProgressIndicator(
            color: A2Colors.primaryLight,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 12),
          const Text(
            'Loading your farm…',
            style: TextStyle(fontSize: 12, color: A2Colors.textHint),
          ),
        ],
      ),
    );
  }
}
