import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/farm_providers.dart';

class KindlingDetailScreen extends ConsumerWidget {
  final String kindlingId;
  const KindlingDetailScreen({super.key, required this.kindlingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kindlingsAsync = ref.watch(kindlingsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kindling Details')),
      body: kindlingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (kindlings) {
          final k = kindlings.where((k) => k.id == kindlingId).firstOrNull;
          if (k == null) return const Center(child: Text('Record not found'));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${k.doeTag} × ${k.buckTag}', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 4),
                    Text(DateFormat('dd MMM yyyy').format(k.kindlingDate), style: AppTextStyles.bodyMedium),
                    const Divider(height: 32),
                    Row(children: [
                      _StatBox('Total Kits', '${k.totalKits}', AppColors.primary),
                      _StatBox('Live Kits', '${k.liveKits}', AppColors.statusActive),
                      _StatBox('Stillborn', '${k.stillbornKits}', AppColors.statusSick),
                    ]),
                    const SizedBox(height: 16),
                    Row(children: [
                      _StatBox('Males', '${k.maleKits}', AppColors.info),
                      _StatBox('Females', '${k.femaleKits}', AppColors.statusPregnant),
                      _StatBox('Survival', '${k.survivalRate.toStringAsFixed(0)}%', AppColors.statusActive),
                    ]),
                    if (k.notes != null) ...[
                      const Divider(height: 32),
                      Text('Notes', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 4),
                      Text(k.notes!, style: AppTextStyles.bodyMedium),
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

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBox(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
