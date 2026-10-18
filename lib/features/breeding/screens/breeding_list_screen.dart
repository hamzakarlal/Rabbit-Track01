import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/breeding_model.dart';
import '../../../providers/farm_providers.dart';

class BreedingListScreen extends ConsumerWidget {
  const BreedingListScreen({super.key});

  Color _statusColor(BreedingStatus s) {
    switch (s) {
      case BreedingStatus.active: return AppColors.statusPregnant;
      case BreedingStatus.successful: return AppColors.statusActive;
      case BreedingStatus.failed: return AppColors.statusSick;
      case BreedingStatus.cancelled: return AppColors.statusDeceased;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breedingsAsync = ref.watch(breedingsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Breeding')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_breeding',
        onPressed: () => context.push('/breeding/add'),
        icon: const Icon(Icons.add),
        label: const Text('Record Breeding'),
      ),
      body: breedingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (breedings) {
          if (breedings.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.favorite_outline, size: 72, color: AppColors.textHint.withValues(alpha: 0.4)),
                const SizedBox(height: 16),
                Text('No breeding records', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 8),
                Text('Record your first breeding event', style: AppTextStyles.bodyMedium),
              ]),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: breedings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final b = breedings[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _statusColor(b.status).withValues(alpha: 0.15),
                    child: Icon(Icons.favorite, color: _statusColor(b.status), size: 20),
                  ),
                  title: Text('${b.buckTag} × ${b.doeTag}', style: AppTextStyles.titleLarge),
                  subtitle: Text(
                      'Bred: ${DateFormat('dd MMM yyyy').format(b.breedingDate)}\n'
                      'Expected kindling: ${DateFormat('dd MMM yyyy').format(b.expectedKindlingDate)}',
                      style: AppTextStyles.bodySmall),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(b.status).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(b.status.displayName,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(b.status))),
                  ),
                  onTap: () => context.push('/breeding/${b.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
