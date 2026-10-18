import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/breeding_model.dart';
import '../../../providers/farm_providers.dart';

import '../../../features/auth/providers/auth_provider.dart';

class AddKindlingScreen extends ConsumerStatefulWidget {
  const AddKindlingScreen({super.key});

  @override
  ConsumerState<AddKindlingScreen> createState() => _AddKindlingScreenState();
}

class _AddKindlingScreenState extends ConsumerState<AddKindlingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _totalCtrl = TextEditingController(text: '0');
  final _liveCtrl = TextEditingController(text: '0');
  final _stillbornCtrl = TextEditingController(text: '0');
  final _maleCtrl = TextEditingController(text: '0');
  final _femaleCtrl = TextEditingController(text: '0');
  final _notesCtrl = TextEditingController();
  DateTime _kindlingDate = DateTime.now();
  BreedingModel? _selectedBreeding;
  bool _loading = false;

  @override
  void dispose() {
    _totalCtrl.dispose(); _liveCtrl.dispose(); _stillbornCtrl.dispose();
    _maleCtrl.dispose(); _femaleCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBreeding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a breeding record')));
      return;
    }
    setState(() => _loading = true);
    final farmId = ref.read(currentFarmIdProvider);
    if (farmId == null) { setState(() => _loading = false); return; }

    final kindling = KindlingModel(
      id: '',
      farmId: farmId,
      breedingId: _selectedBreeding!.id,
      doeId: _selectedBreeding!.doeId,
      doeTag: _selectedBreeding!.doeTag,
      buckId: _selectedBreeding!.buckId,
      buckTag: _selectedBreeding!.buckTag,
      kindlingDate: _kindlingDate,
      expectedDate: _selectedBreeding!.expectedKindlingDate,
      totalKits: int.tryParse(_totalCtrl.text) ?? 0,
      liveKits: int.tryParse(_liveCtrl.text) ?? 0,
      stillbornKits: int.tryParse(_stillbornCtrl.text) ?? 0,
      maleKits: int.tryParse(_maleCtrl.text) ?? 0,
      femaleKits: int.tryParse(_femaleCtrl.text) ?? 0,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.read(breedingNotifierProvider.notifier).addKindling(kindling);
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final breedingsAsync = ref.watch(activeBreedingsStreamProvider);
    final activeBreedings = breedingsAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Record Kindling')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<BreedingModel>(
              initialValue: _selectedBreeding,
              decoration: const InputDecoration(labelText: 'Breeding Record *'),
              items: activeBreedings.map((b) => DropdownMenuItem(
                  value: b, child: Text('${b.doeTag} × ${b.buckTag}'))).toList(),
              onChanged: (v) => setState(() => _selectedBreeding = v),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Kindling Date'),
              subtitle: Text(DateFormat('dd MMM yyyy').format(_kindlingDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _kindlingDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (d != null) setState(() => _kindlingDate = d);
              },
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextFormField(controller: _totalCtrl, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Total Kits'))),
              const SizedBox(width: 8),
              Expanded(child: TextFormField(controller: _liveCtrl, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Live Kits'))),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextFormField(controller: _stillbornCtrl, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stillborn'))),
              const SizedBox(width: 8),
              Expanded(child: TextFormField(controller: _maleCtrl, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Male Kits'))),
              const SizedBox(width: 8),
              Expanded(child: TextFormField(controller: _femaleCtrl, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Female Kits'))),
            ]),
            const SizedBox(height: 12),
            TextFormField(controller: _notesCtrl, maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes')),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save Kindling Record'),
            ),
          ],
        ),
      ),
    );
  }
}
