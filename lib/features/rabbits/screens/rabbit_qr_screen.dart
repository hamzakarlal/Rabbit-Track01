import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/rabbit_provider.dart';

class RabbitQrScreen extends ConsumerWidget {
  final String rabbitId;
  const RabbitQrScreen({super.key, required this.rabbitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rabbitAsync = ref.watch(rabbitDetailProvider(rabbitId));

    return Scaffold(
      appBar: AppBar(title: const Text('Rabbit QR Code')),
      body: rabbitAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (rabbit) {
          if (rabbit == null) {
            return const Center(child: Text('Rabbit not found'));
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(24),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(rabbit.displayName,
                            style: AppTextStyles.headlineMedium),
                        Text('Tag: ${rabbit.earTag}',
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 24),
                        QrImageView(
                          data: rabbit.id,
                          size: 200,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text('Scan to view rabbit details',
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
