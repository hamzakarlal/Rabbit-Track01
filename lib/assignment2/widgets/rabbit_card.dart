import 'package:flutter/material.dart';

import '../models/rabbit.dart';
import '../theme/a2_theme.dart';

// ============================================================
// RabbitCard — the REUSABLE custom widget for the main entity.
//
// It takes constructor parameters (a [rabbit] entity plus the
// [imagePath] of its photo) and is used 5 times on the Home
// screen with different dummy data, as the assignment requires.
// Built with Unit 3 building blocks: Card, Row, Column,
// Expanded, Padding, SizedBox, asset image and Icons.
// ============================================================
class RabbitCard extends StatelessWidget {
  final Rabbit rabbit;
  final String imagePath;

  const RabbitCard({
    super.key,
    required this.rabbit,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rabbit photo — asset image with rounded corners.
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 74,
                height: 74,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            // Expanded keeps this Column inside the remaining Row
            // width, so the card never overflows on small screens.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: rabbit name + tag number chip.
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          rabbit.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: A2Colors.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: A2Colors.surfaceGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          rabbit.tagNumber,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: A2Colors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Row 2: breed + gender with an icon.
                  Row(
                    children: [
                      const Icon(
                        Icons.pets,
                        size: 15,
                        color: A2Colors.primaryLight,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${rabbit.breed}  •  ${rabbit.gender}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: A2Colors.textGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Row 3: cage number + date of birth.
                  Row(
                    children: [
                      const Icon(
                        Icons.home_work_outlined,
                        size: 15,
                        color: A2Colors.primaryLight,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Cage ${rabbit.cageNumber}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: A2Colors.textGrey,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.cake_outlined,
                        size: 15,
                        color: A2Colors.primaryLight,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          rabbit.dateOfBirth,
                          style: const TextStyle(
                            fontSize: 12,
                            color: A2Colors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
