import 'package:flutter/material.dart';

import '../theme/a2_theme.dart';

// ============================================================
// VaccinationScreen — the vaccination schedule of the farm
// (static screen with dummy data).
//
// Layout practice (Unit 3): two summary chips in a Row with
// Expanded, section headers, and a reusable _VaccinationCard
// used 5 times with different dummy records.
// ============================================================
class VaccinationScreen extends StatelessWidget {
  const VaccinationScreen({super.key});

  // Dummy vaccination records (rabbitName is shown under each vaccine).
  static const List<VaccinationRecord> _upcoming = [
    VaccinationRecord(
      vaccineName: 'RHDV Booster',
      rabbitName: 'Snowy',
      date: '25 Oct 2026',
      done: false,
    ),
    VaccinationRecord(
      vaccineName: 'Myxomatosis Vaccine',
      rabbitName: 'Shadow',
      date: '02 Nov 2026',
      done: false,
    ),
    VaccinationRecord(
      vaccineName: 'RHDV Booster',
      rabbitName: 'Brownie',
      date: '10 Nov 2026',
      done: false,
    ),
  ];

  static const List<VaccinationRecord> _completed = [
    VaccinationRecord(
      vaccineName: 'Myxomatosis Vaccine',
      rabbitName: 'Coco',
      date: '30 Sep 2026',
      done: true,
    ),
    VaccinationRecord(
      vaccineName: 'RHDV',
      rabbitName: 'Snowy',
      date: '12 Aug 2026',
      done: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vaccination Schedule')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Summary chips (Row + Expanded) ----
            Row(
              children: [
                const Expanded(
                  child: _SummaryChip(
                    icon: Icons.schedule,
                    value: '3',
                    label: 'Upcoming',
                    iconColor: A2Colors.amber,
                    iconBackground: Color(0x33F4A261),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: _SummaryChip(
                    icon: Icons.check_circle,
                    value: '2',
                    label: 'Completed',
                    iconColor: A2Colors.primary,
                    iconBackground: A2Colors.surfaceGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ---- Upcoming section ----
            const Text(
              'Upcoming Vaccinations',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: A2Colors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            ..._upcoming.map((v) => _VaccinationCard(record: v)),
            const SizedBox(height: 24),

            // ---- Completed section ----
            const Text(
              'Recently Completed',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: A2Colors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            ..._completed.map((v) => _VaccinationCard(record: v)),
          ],
        ),
      ),
    );
  }
}

// Small data class for one dummy vaccination record.
class VaccinationRecord {
  final String vaccineName;
  final String rabbitName;
  final String date;
  final bool done;

  const VaccinationRecord({
    required this.vaccineName,
    required this.rabbitName,
    required this.date,
    required this.done,
  });
}

// Reusable card for one vaccination record.
class _VaccinationCard extends StatelessWidget {
  final VaccinationRecord record;

  const _VaccinationCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon in a colored circle: green = done, amber = upcoming.
            CircleAvatar(
              radius: 20,
              backgroundColor: record.done
                  ? A2Colors.surfaceGreen
                  : const Color(0x33F4A261),
              child: Icon(
                record.done ? Icons.check_circle : Icons.vaccines,
                size: 20,
                color: record.done ? A2Colors.primary : A2Colors.amber,
              ),
            ),
            const SizedBox(width: 12),

            // Vaccine name + rabbit name + date.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.vaccineName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: A2Colors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.cruelty_free,
                        size: 13,
                        color: A2Colors.textGrey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          record.rabbitName,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: A2Colors.textGrey,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.event_outlined,
                        size: 13,
                        color: A2Colors.textGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        record.date,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: A2Colors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Status pill.
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: record.done
                    ? A2Colors.surfaceGreen
                    : const Color(0x33F4A261),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                record.done ? 'Done' : 'Upcoming',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: record.done
                      ? A2Colors.primaryDark
                      : const Color(0xFFB86A1B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable summary chip (big value + label + colored icon).
class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final Color iconBackground;

  const _SummaryChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: iconBackground,
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: A2Colors.primaryDark,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: A2Colors.textGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
