import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedingListScreen extends ConsumerWidget {
  const FeedingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feeding')),
      body: const Center(child: Text('Feeding List Placeholder')),
    );
  }
}
