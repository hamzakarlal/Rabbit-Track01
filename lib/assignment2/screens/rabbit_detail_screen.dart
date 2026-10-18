import 'package:flutter/material.dart';

import '../models/rabbit.dart';
import '../theme/a2_theme.dart';

// ============================================================
// RabbitDetailScreen — full information about ONE rabbit
// (static screen; it receives the Rabbit entity through its
// constructor).
//
// Layout practice (Unit 3): a large photo with a gradient name
// banner, a Card with information Rows (icon + label + value),
// a vaccination history list, and a notes Card. Everything is
// inside a SingleChildScrollView, so it scrolls safely.
// ============================================================
class RabbitDetailScreen extends StatelessWidget {
  final Rabbit rabbit;
  final String imagePath;

  const RabbitDetailScreen({
    super.key,
    required this.rabbit,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rabbit Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Photo with the rabbit's name on a gradient ----
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Image.asset(
                    imagePath,
                    height: 230,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rabbit.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${rabbit.tagNumber}  •  ${rabbit.breed}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---- Basic information card ----
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: A2Colors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: rabbit.gender == 'Male'
                          ? Icons.male
                          : Icons.female,
                      label: 'Gender',
                      value: rabbit.gender,
                    ),
                    const Divider(color: A2Colors.border, height: 1),
                    _InfoRow(
                      icon: Icons.home_work_outlined,
                      label: 'Cage Number',
                      value: rabbit.cageNumber,
                    ),
                    const Divider(color: A2Colors.border, height: 1),
                    _InfoRow(
                      icon: Icons.cake_outlined,
                      label: 'Date of Birth',
                      value: rabbit.dateOfBirth,
                    ),
                    const Divider(color: A2Colors.border, height: 1),
                    _InfoRow(
                      icon: Icons.tag,
                      label: 'Tag Number',
                      value: rabbit.tagNumber,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ---- Vaccination history (dummy) ----
            const Text(
              'Health & Vaccination',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: A2Colors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                child: Column(
                  children: const [
                    _HealthRow(
                      icon: Icons.vaccines,
                      title: 'RHDV Booster',
                      subtitle: 'Due on 02 Nov 2026',
                      done: false,
                    ),
                    Divider(color: A2Colors.border, height: 1),
                    _HealthRow(
                      icon: Icons.vaccines,
                      title: 'Myxomatosis Vaccine',
                      subtitle: 'Given on 30 Sep 2026',
                      done: true,
                    ),
                    Divider(color: A2Colors.border, height: 1),
                    _HealthRow(
                      icon: Icons.monitor_heart_outlined,
                      title: 'Health Checkup',
                      subtitle: 'Done on 15 Aug 2026',
                      done: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ---- Notes (dummy text) ----
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: A2Colors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${rabbit.name} is healthy and active, with a good appetite '
                  'and a calm temperament. Keep monitoring weight weekly and '
                  'refresh the straw bedding every three days.',
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: A2Colors.textGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable row: icon in a green circle + label + value.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: A2Colors.surfaceGreen,
            child: Icon(icon, size: 17, color: A2Colors.primary),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: A2Colors.textGrey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: A2Colors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable row for a health/vaccination entry with a status pill.
class _HealthRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool done;

  const _HealthRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: done
                ? A2Colors.surfaceGreen
                : const Color(0x33F4A261),
            child: Icon(
              done ? Icons.check_circle : icon,
              size: 17,
              color: done ? A2Colors.primary : A2Colors.amber,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: A2Colors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: A2Colors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: done ? A2Colors.surfaceGreen : const Color(0x33F4A261),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              done ? 'Done' : 'Upcoming',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: done ? A2Colors.primaryDark : const Color(0xFFB86A1B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
