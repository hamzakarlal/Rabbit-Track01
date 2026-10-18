import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddVaccinationScreen extends ConsumerStatefulWidget {
  const AddVaccinationScreen({super.key});

  @override
  ConsumerState<AddVaccinationScreen> createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends ConsumerState<AddVaccinationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vaccination')),
      body: const Center(child: Text('Add Vaccination Placeholder')),
    );
  }
}
