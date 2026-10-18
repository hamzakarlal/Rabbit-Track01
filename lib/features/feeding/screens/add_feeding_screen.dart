import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFeedingScreen extends ConsumerStatefulWidget {
  const AddFeedingScreen({super.key});

  @override
  ConsumerState<AddFeedingScreen> createState() => _AddFeedingScreenState();
}

class _AddFeedingScreenState extends ConsumerState<AddFeedingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Feeding Record')),
      body: const Center(child: Text('Add Feeding Placeholder')),
    );
  }
}
