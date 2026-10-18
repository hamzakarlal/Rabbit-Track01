import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaleDetailScreen extends ConsumerWidget {
  final String saleId;
  const SaleDetailScreen({super.key, required this.saleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sale Details')),
      body: Center(child: Text('Sale Detail Placeholder: $saleId')),
    );
  }
}
