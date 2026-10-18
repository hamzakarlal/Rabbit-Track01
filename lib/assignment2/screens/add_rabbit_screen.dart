import 'package:flutter/material.dart';

import '../theme/a2_theme.dart';

// ============================================================
// AddRabbitScreen — the input screen of Rabbit Track (LOOK
// ONLY, as the assignment says: "It does not need to work yet").
//
// Layout practice (Unit 3): photo placeholder, TextFields with
// prefix icons, a DropdownButtonFormField for the breed, a
// Row with two gender options, and a full-width Save button.
// Real saving is added in Assignment 4.
// ============================================================
class AddRabbitScreen extends StatelessWidget {
  const AddRabbitScreen({super.key});

  // Dummy breed list for the dropdown.
  static const List<String> _breeds = [
    'New Zealand White',
    'Dutch',
    'Rex',
    'Lop',
    'Californian',
    'Angora',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Rabbit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Photo placeholder with a camera badge ----
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: A2Colors.surfaceGreen,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 86,
                        height: 86,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: A2Colors.primary,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Add rabbit photo',
                style: TextStyle(fontSize: 12, color: A2Colors.textHint),
              ),
            ),
            const SizedBox(height: 24),

            // ---- TextFields (one per entity field) ----
            const TextField(
              decoration: InputDecoration(
                labelText: 'Rabbit Name',
                hintText: 'e.g. Snowy',
                prefixIcon: Icon(Icons.pets_outlined),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Tag Number',
                hintText: 'e.g. RT-006',
                prefixIcon: Icon(Icons.tag),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Breed',
                hintText: 'Select breed',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: _breeds
                  .map(
                    (b) => DropdownMenuItem(value: b, child: Text(b)),
                  )
                  .toList(),
              onChanged: (value) {}, // look only — no logic yet
            ),
            const SizedBox(height: 16),

            // ---- Gender selection (static look, no state) ----
            const Text(
              'Gender',
              style: TextStyle(fontSize: 13, color: A2Colors.textGrey),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(
                  child: _GenderOption(
                    icon: Icons.male,
                    label: 'Male',
                    selected: true,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _GenderOption(
                    icon: Icons.female,
                    label: 'Female',
                    selected: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Cage Number',
                hintText: 'e.g. B-09',
                prefixIcon: Icon(Icons.home_work_outlined),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'dd MMM yyyy',
                prefixIcon: Icon(Icons.calendar_month_outlined),
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
            ),
            const SizedBox(height: 28),

            // ---- Save button (dummy action only) ----
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dummy save — real saving comes in Assignment 4'),
                    backgroundColor: A2Colors.primaryDark,
                  ),
                );
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Rabbit'),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'This form is for design only — it becomes functional in Assignment 3.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: A2Colors.textHint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// One selectable-looking gender option (a decorated Container).
class _GenderOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _GenderOption({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: selected ? A2Colors.surfaceGreen : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? A2Colors.primary : A2Colors.border,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 19,
            color: selected ? A2Colors.primary : A2Colors.textHint,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? A2Colors.primaryDark : A2Colors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
