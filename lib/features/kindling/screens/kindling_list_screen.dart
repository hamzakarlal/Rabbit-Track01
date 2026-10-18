import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';

import '../../../providers/farm_providers.dart';

class KindlingListScreen extends ConsumerWidget {
  const KindlingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kindlingsAsync = ref.watch(kindlingsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Kindling Records')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_kindling',
        onPressed: () => context.push('/kindling/add'),
        icon: const Icon(Icons.add),
        label: const Text('Record Kindling'),
      ),
      body: kindlingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (kindlings) {
          if (kindlings.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.child_care_outlined, size: 72, color: AppColors.textHint.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text('No kindling records', style: AppTextStyles.headlineSmall),
            ]));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: kindlings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final k = kindlings[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primarySurface,
                    child: Text('${k.liveKits}', style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary)),
                  ),
                  title: Text('${k.doeTag} × ${k.buckTag}', style: AppTextStyles.titleLarge),
                  subtitle: Text(
                    '${DateFormat('dd MMM yyyy').format(k.kindlingDate)} • ${k.liveKits} live / ${k.totalKits} total',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/kindling/${k.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
