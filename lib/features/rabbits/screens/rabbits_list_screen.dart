import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/rabbit_model.dart';
import '../../../providers/rabbit_provider.dart';

class RabbitsListScreen extends ConsumerWidget {
  const RabbitsListScreen({super.key});

  Color _statusColor(RabbitStatus s) {
    switch (s) {
      case RabbitStatus.active: return AppColors.statusActive;
      case RabbitStatus.sick: return AppColors.statusSick;
      case RabbitStatus.pregnant: return AppColors.statusPregnant;
      case RabbitStatus.sold: return AppColors.statusSold;
      case RabbitStatus.deceased: return AppColors.statusDeceased;
      case RabbitStatus.retired: return AppColors.statusRetired;
      default: return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitsAsync = ref.watch(rabbitsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rabbits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () => context.push('/qr-scanner'),
            tooltip: 'Scan QR',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_rabbit',
        onPressed: () => context.push('/rabbits/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Rabbit'),
      ),
      body: rabbitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (rabbits) {
          if (rabbits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 80,
                      color: AppColors.textHint.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text('No rabbits yet', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Add your first rabbit to get started',
                      style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/rabbits/add'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Rabbit'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: rabbits.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final rabbit = rabbits[i];
              final label = rabbit.earTag.length >= 2
                  ? rabbit.earTag.substring(0, 2).toUpperCase()
                  : rabbit.earTag.toUpperCase();
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primarySurface,
                    child: Text(
                      label,
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                  title: Text(rabbit.displayName,
                      style: AppTextStyles.titleLarge),
                  subtitle: Text(
                      '${rabbit.breed} • ${rabbit.gender.shortName} • ${rabbit.ageDisplay}',
                      style: AppTextStyles.bodySmall),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(rabbit.status)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      rabbit.status.displayName,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _statusColor(rabbit.status)),
                    ),
                  ),
                  onTap: () => context.push('/rabbits/${rabbit.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
