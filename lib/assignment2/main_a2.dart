// ignore_for_file: unused_import
// ^ The imports below are intentionally all kept: this file is
//   the Assignment 2 "screen preview" entry point. To view a
//   different screen you simply change `home:` (the assignment
//   workflow), so some imports are only used while previewing.

// ============================================================
// Rabbit Track — Assignment 2 entry point (Project UI, Unit 3).
//
// Run with:   flutter run -t lib/assignment2/main_a2.dart
//
// This is a STATIC UI preview: no navigation, no database and
// no APIs — only widgets, layouts, images, icons and Cards.
// To view another screen, change `home:` below and hot restart.
// (The full Firebase app still starts from lib/main.dart.)
// ============================================================
import 'package:flutter/material.dart';

import 'models/rabbit.dart';
import 'screens/add_rabbit_screen.dart';
import 'screens/home_screen.dart';
import 'screens/rabbit_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/vaccination_screen.dart';
import 'theme/a2_theme.dart';

void main() {
  runApp(const RabbitTrackUIApp());
}

class RabbitTrackUIApp extends StatelessWidget {
  const RabbitTrackUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rabbit Track', // app name
      debugShowCheckedModeBanner: false, // required by the assignment
      theme: A2Theme.theme, // one theme shared by every screen

      // ──────────────────────────────────────────────────────
      // CHANGE `home:` BELOW TO PREVIEW EACH SCREEN,
      // then hot restart and take a screenshot.
      // ──────────────────────────────────────────────────────
      home: const HomeScreen(),
      // home: const SplashScreen(),
      // home: RabbitDetailScreen(
      //   rabbit: dummyRabbits[1],
      //   imagePath: 'assets/images/rabbit_dutch.png',
      // ),
      // home: const AddRabbitScreen(),
      // home: const VaccinationScreen(),
    );
  }
}
