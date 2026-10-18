import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/breeding_model.dart';
import '../../../models/rabbit_model.dart';
import '../../../providers/farm_providers.dart';
import '../../../providers/rabbit_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';

class AddBreedingScreen extends ConsumerStatefulWidget {
  const AddBreedingScreen({super.key});

  @override
  ConsumerState<AddBreedingScreen> createState() => _AddBreedingScreenState();
}

class _AddBreedingScreenState extends ConsumerState<AddBreedingScreen> {
  final _formKey = GlobalKey<FormState>();
  RabbitModel? _selectedBuck;
  RabbitModel? _selectedDoe;
  DateTime _breedingDate = DateTime.now();
  final _notesCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _breedingDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _breedingDate = d);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBuck == null || _selectedDoe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both buck and doe')));
      return;
    }
    setState(() => _loading = true);
    final farmId = ref.read(currentFarmIdProvider);
    if (farmId == null) { setState(() => _loading = false); return; }

    final breeding = BreedingModel(
      id: '',
      farmId: farmId,
      buckId: _selectedBuck!.id,
      buckTag: _selectedBuck!.earTag,
      doeId: _selectedDoe!.id,
      doeTag: _selectedDoe!.earTag,
      breedingDate: _breedingDate,
      expectedKindlingDate: BreedingModel.calculateExpectedKindling(_breedingDate),
      status: BreedingStatus.active,
      numberOfAttempts: 1,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.read(breedingNotifierProvider.notifier).addBreeding(breeding);
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rabbitsAsync = ref.watch(rabbitsStreamProvider);
    final bucks = rabbitsAsync.valueOrNull
            ?.where((r) => r.gender == RabbitGender.male && r.status == RabbitStatus.active)
            .toList() ?? [];
    final does = rabbitsAsync.valueOrNull
            ?.where((r) => r.gender == RabbitGender.female && r.status == RabbitStatus.active)
            .toList() ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Record Breeding')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<RabbitModel>(
              initialValue: _selectedBuck,
              decoration: const InputDecoration(labelText: 'Buck (Male) *', prefixIcon: Icon(Icons.male)),
              items: bucks.map((r) => DropdownMenuItem(value: r, child: Text('${r.earTag} - ${r.displayName}'))).toList(),
              onChanged: (v) => setState(() => _selectedBuck = v),
              validator: (v) => v == null ? 'Select a buck' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RabbitModel>(
              initialValue: _selectedDoe,
              decoration: const InputDecoration(labelText: 'Doe (Female) *', prefixIcon: Icon(Icons.female)),
              items: does.map((r) => DropdownMenuItem(value: r, child: Text('${r.earTag} - ${r.displayName}'))).toList(),
              onChanged: (v) => setState(() => _selectedDoe = v),
              validator: (v) => v == null ? 'Select a doe' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Breeding Date'),
              subtitle: Text(DateFormat('dd MMM yyyy').format(_breedingDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Expected kindling: ${DateFormat('dd MMM yyyy').format(BreedingModel.calculateExpectedKindling(_breedingDate))}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes', prefixIcon: Icon(Icons.notes_outlined)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save Breeding Record'),
            ),
          ],
        ),
      ),
    );
  }
}
