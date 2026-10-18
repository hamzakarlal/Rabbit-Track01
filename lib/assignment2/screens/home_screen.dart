import 'package:flutter/material.dart';

import '../models/rabbit.dart';
import '../theme/a2_theme.dart';
import '../widgets/rabbit_card.dart';

// ============================================================
// HomeScreen — main screen of Rabbit Track (static).
//
// Layout practice (Unit 3): banner asset image with a gradient
// caption, a summary Row with three Expanded cards, and the
// rabbit list built from the reusable RabbitCard widget used
// 5 times with different dummy data.
// The whole body is inside a SingleChildScrollView so long
// content can never overflow.
// ============================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Consistent themed AppBar (green, centered title) + logo
      // image in the leading slot and meaningful icons in actions.
      appBar: AppBar(
        title: const Text('Rabbit Track'),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
          ),
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 8),
          Icon(Icons.notifications_outlined),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Banner image with a gradient caption ----
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/banner.png',
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xD91B4332), Colors.transparent],
                        ),
                      ),
                      child: const Text(
                        'Welcome to Rabbit Track Farm!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---- Farm summary: Row + Expanded (never overflows) ----
            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.cruelty_free,
                    value: '5',
                    label: 'Rabbits',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.home_work_outlined,
                    value: '8',
                    label: 'Cages',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.vaccines,
                    value: '3',
                    label: 'Vaccines due',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ---- Section header ----
            Row(
              children: [
                const Text(
                  'My Rabbits',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: A2Colors.textDark,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {}, // look only — no navigation yet
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // ---- Rabbit list: RabbitCard used 5 times ----
            RabbitCard(
              rabbit: dummyRabbits[0],
              imagePath: 'assets/images/rabbit_white.png',
            ),
            RabbitCard(
              rabbit: dummyRabbits[1],
              imagePath: 'assets/images/rabbit_dutch.png',
            ),
            RabbitCard(
              rabbit: dummyRabbits[2],
              imagePath: 'assets/images/rabbit_rex.png',
            ),
            RabbitCard(
              rabbit: dummyRabbits[3],
              imagePath: 'assets/images/rabbit_lop.png',
            ),
            RabbitCard(
              rabbit: dummyRabbits[4],
              imagePath: 'assets/images/rabbit_white.png',
            ),
          ],
        ),
      ),
    );
  }
}

// A small reusable summary card used in the Row above
// (icon inside a colored circle, big value, grey label).
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: A2Colors.surfaceGreen,
              child: Icon(icon, size: 20, color: A2Colors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: A2Colors.primaryDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: A2Colors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
