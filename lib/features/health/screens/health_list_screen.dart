import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/health_model.dart';
import '../../../providers/farm_providers.dart';

class HealthListScreen extends ConsumerWidget {
  const HealthListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(healthRecordsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Health Records')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_health',
        onPressed: () => context.push('/health/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
      ),
      body: healthAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (records) {
          if (records.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.medical_services_outlined, size: 72, color: AppColors.textHint.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text('No health records', style: AppTextStyles.headlineSmall),
            ]));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: records.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final r = records[i];
              final isOngoing = r.isOngoing;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isOngoing
                        ? AppColors.statusSick.withValues(alpha: 0.15)
                        : AppColors.statusActive.withValues(alpha: 0.15),
                    child: Icon(
                      isOngoing ? Icons.sick_outlined : Icons.check_circle_outline,
                      color: isOngoing ? AppColors.statusSick : AppColors.statusActive,
                      size: 20,
                    ),
                  ),
                  title: Text(r.rabbitTag, style: AppTextStyles.titleLarge),
                  subtitle: Text(
                    '${r.status.displayName} • ${DateFormat('dd MMM yyyy').format(r.date)}'
                    '${r.diagnosis != null ? '\n${r.diagnosis}' : ''}',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: r.cost != null
                      ? Text('PKR ${r.cost!.toStringAsFixed(0)}',
                          style: AppTextStyles.labelLarge.copyWith(color: AppColors.accentOrange))
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
