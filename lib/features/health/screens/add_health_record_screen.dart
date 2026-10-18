import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/health_model.dart';
import '../../../providers/farm_providers.dart';
import '../../../providers/rabbit_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';

class AddHealthRecordScreen extends ConsumerStatefulWidget {
  const AddHealthRecordScreen({super.key});

  @override
  ConsumerState<AddHealthRecordScreen> createState() => _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends ConsumerState<AddHealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsCtrl = TextEditingController();
  final _diagnosisCtrl = TextEditingController();
  final _treatmentCtrl = TextEditingController();
  final _medicineCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  HealthStatus _status = HealthStatus.sick;
  String? _selectedRabbitId;
  String? _selectedRabbitTag;
  bool _loading = false;

  @override
  void dispose() {
    _symptomsCtrl.dispose(); _diagnosisCtrl.dispose(); _treatmentCtrl.dispose();
    _medicineCtrl.dispose(); _costCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRabbitId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a rabbit')));
      return;
    }
    setState(() => _loading = true);
    final farmId = ref.read(currentFarmIdProvider);
    if (farmId == null) { setState(() => _loading = false); return; }

    final record = HealthRecordModel(
      id: '',
      farmId: farmId,
      rabbitId: _selectedRabbitId!,
      rabbitTag: _selectedRabbitTag!,
      date: _date,
      symptoms: _symptomsCtrl.text.trim().isEmpty ? null : _symptomsCtrl.text.trim(),
      diagnosis: _diagnosisCtrl.text.trim().isEmpty ? null : _diagnosisCtrl.text.trim(),
      treatment: _treatmentCtrl.text.trim().isEmpty ? null : _treatmentCtrl.text.trim(),
      medicine: _medicineCtrl.text.trim().isEmpty ? null : _medicineCtrl.text.trim(),
      status: _status,
      cost: double.tryParse(_costCtrl.text),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.read(healthNotifierProvider.notifier).addHealthRecord(record);
    if (mounted) { setState(() => _loading = false); Navigator.pop(context); }
  }

  @override
  Widget build(BuildContext context) {
    final rabbitsAsync = ref.watch(rabbitsStreamProvider);
    final rabbits = rabbitsAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Add Health Record')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedRabbitId,
              decoration: const InputDecoration(labelText: 'Rabbit *', prefixIcon: Icon(Icons.pets_outlined)),
              items: rabbits.map((r) => DropdownMenuItem(
                  value: r.id, child: Text('${r.earTag} - ${r.displayName}'))).toList(),
              onChanged: (v) {
                final r = rabbits.firstWhere((r) => r.id == v);
                setState(() { _selectedRabbitId = v; _selectedRabbitTag = r.earTag; });
              },
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Date'),
              subtitle: Text(DateFormat('dd MMM yyyy').format(_date)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date,
                    firstDate: DateTime(2020), lastDate: DateTime.now());
                if (d != null) setState(() => _date = d);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<HealthStatus>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: HealthStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.displayName))).toList(),
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(controller: _symptomsCtrl, maxLines: 2,
                decoration: const InputDecoration(labelText: 'Symptoms', prefixIcon: Icon(Icons.warning_amber_outlined))),
            const SizedBox(height: 12),
            TextFormField(controller: _diagnosisCtrl,
                decoration: const InputDecoration(labelText: 'Diagnosis', prefixIcon: Icon(Icons.search_outlined))),
            const SizedBox(height: 12),
            TextFormField(controller: _treatmentCtrl,
                decoration: const InputDecoration(labelText: 'Treatment', prefixIcon: Icon(Icons.healing_outlined))),
            const SizedBox(height: 12),
            TextFormField(controller: _medicineCtrl,
                decoration: const InputDecoration(labelText: 'Medicine', prefixIcon: Icon(Icons.medication_outlined))),
            const SizedBox(height: 12),
            TextFormField(controller: _costCtrl, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cost (PKR)', prefixIcon: Icon(Icons.attach_money))),
            const SizedBox(height: 12),
            TextFormField(controller: _notesCtrl, maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes')),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save Health Record'),
            ),
          ],
        ),
      ),
    );
  }
}
