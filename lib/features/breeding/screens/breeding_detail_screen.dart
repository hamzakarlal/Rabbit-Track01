import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/breeding_model.dart';
import '../../../providers/farm_providers.dart';

class BreedingDetailScreen extends ConsumerWidget {
  final String breedingId;
  const BreedingDetailScreen({super.key, required this.breedingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedingsAsync = ref.watch(breedingsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Breeding Details')),
      body: breedingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (breedings) {
          final breeding = breedings.where((b) => b.id == breedingId).firstOrNull;
          if (breeding == null) return const Center(child: Text('Record not found'));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${breeding.buckTag} × ${breeding.doeTag}', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 4),
                    Text(breeding.status.displayName,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                    const Divider(height: 32),
                    _InfoRow('Breeding Date', DateFormat('dd MMM yyyy').format(breeding.breedingDate)),
                    _InfoRow('Expected Kindling', DateFormat('dd MMM yyyy').format(breeding.expectedKindlingDate)),
                    if (breeding.actualKindlingDate != null)
                      _InfoRow('Actual Kindling', DateFormat('dd MMM yyyy').format(breeding.actualKindlingDate!)),
                    _InfoRow('Attempts', '${breeding.numberOfAttempts}'),
                    if (breeding.notes != null) ...[
                      const SizedBox(height: 12),
                      Text('Notes', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 4),
                      Text(breeding.notes!, style: AppTextStyles.bodyMedium),
                    ],
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        SizedBox(width: 140, child: Text(label, style: AppTextStyles.bodySmall)),
        Expanded(child: Text(value, style: AppTextStyles.bodyLarge)),
      ]),
    );
  }
}
