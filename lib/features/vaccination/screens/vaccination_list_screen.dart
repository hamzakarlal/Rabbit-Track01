import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VaccinationListScreen extends ConsumerWidget {
  const VaccinationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vaccinations')),
      body: const Center(child: Text('Vaccination List Screen Placeholder')),
    );
  }
}
