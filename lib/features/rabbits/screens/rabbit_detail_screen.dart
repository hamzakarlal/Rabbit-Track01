import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/rabbit_model.dart';
import '../../../providers/rabbit_provider.dart';

class RabbitDetailScreen extends ConsumerWidget {
  final String rabbitId;
  const RabbitDetailScreen({super.key, required this.rabbitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitAsync = ref.watch(rabbitDetailProvider(rabbitId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rabbit Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_outlined),
            onPressed: () => context.push('/rabbits/$rabbitId/qr'),
            tooltip: 'QR Code',
          ),
        ],
      ),
      body: rabbitAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (rabbit) {
          if (rabbit == null) {
            return const Center(child: Text('Rabbit not found'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.primarySurface,
                            child: Icon(Icons.pets, size: 32, color: AppColors.primary),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(rabbit.displayName, style: AppTextStyles.headlineMedium),
                                Text('Tag: ${rabbit.earTag}', style: AppTextStyles.bodyMedium),
                                Text(rabbit.status.displayName,
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _InfoRow(label: 'Gender', value: rabbit.gender.displayName),
                      _InfoRow(label: 'Breed', value: rabbit.breed),
                      _InfoRow(label: 'Age', value: rabbit.ageDisplay),
                      _InfoRow(label: 'Date of Birth',
                          value: DateFormat('dd MMM yyyy').format(rabbit.dateOfBirth)),
                      if (rabbit.weight != null)
                        _InfoRow(label: 'Weight', value: '${rabbit.weight!.toStringAsFixed(2)} kg'),
                      if (rabbit.color != null)
                        _InfoRow(label: 'Color', value: rabbit.color!),
                      if (rabbit.cageNumber != null)
                        _InfoRow(label: 'Cage', value: rabbit.cageNumber!),
                      if (rabbit.notes != null) ...[
                        const SizedBox(height: 12),
                        Text('Notes', style: AppTextStyles.labelLarge),
                        const SizedBox(height: 4),
                        Text(rabbit.notes!, style: AppTextStyles.bodyMedium),
                      ],
                    ],
                  ),
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
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyLarge)),
        ],
      ),
    );
  }
}
