import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/rabbit_model.dart';
import '../../../providers/rabbit_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';

class AddRabbitScreen extends ConsumerStatefulWidget {
  final String? parentId;
  const AddRabbitScreen({super.key, this.parentId});

  @override
  ConsumerState<AddRabbitScreen> createState() => _AddRabbitScreenState();
}

class _AddRabbitScreenState extends ConsumerState<AddRabbitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _earTagCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _breedCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _cageCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  RabbitGender _gender = RabbitGender.male;
  DateTime _dob = DateTime.now().subtract(const Duration(days: 90));
  bool _loading = false;

  @override
  void dispose() {
    _earTagCtrl.dispose();
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _colorCtrl.dispose();
    _weightCtrl.dispose();
    _cageCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _dob = d);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final farmId = ref.read(currentFarmIdProvider);
    if (farmId == null) {
      setState(() => _loading = false);
      return;
    }
    final rabbit = RabbitModel(
      id: '',
      farmId: farmId,
      earTag: _earTagCtrl.text.trim(),
      name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
      gender: _gender,
      breed: _breedCtrl.text.trim(),
      color: _colorCtrl.text.trim().isEmpty ? null : _colorCtrl.text.trim(),
      dateOfBirth: _dob,
      weight: double.tryParse(_weightCtrl.text),
      status: RabbitStatus.active,
      cageNumber: _cageCtrl.text.trim().isEmpty ? null : _cageCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.read(rabbitCrudProvider.notifier).addRabbit(rabbit);
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Rabbit')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _earTagCtrl,
              decoration: const InputDecoration(
                  labelText: 'Ear Tag *', prefixIcon: Icon(Icons.tag)),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Name (optional)',
                  prefixIcon: Icon(Icons.pets_outlined)),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RabbitGender>(
              initialValue: _gender,
              decoration: const InputDecoration(
                  labelText: 'Gender', prefixIcon: Icon(Icons.wc)),
              items: RabbitGender.values
                  .map((g) => DropdownMenuItem(
                      value: g, child: Text(g.displayName)))
                  .toList(),
              onChanged: (v) => setState(() => _gender = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _breedCtrl,
              decoration: const InputDecoration(
                  labelText: 'Breed *',
                  prefixIcon: Icon(Icons.category_outlined)),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Date of Birth'),
              subtitle:
                  Text(DateFormat('dd MMM yyyy').format(_dob)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _colorCtrl,
              decoration: const InputDecoration(
                  labelText: 'Color',
                  prefixIcon: Icon(Icons.color_lens_outlined)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weightCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.monitor_weight_outlined)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cageCtrl,
              decoration: const InputDecoration(
                  labelText: 'Cage Number',
                  prefixIcon: Icon(Icons.grid_4x4)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.notes_outlined)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Save Rabbit'),
            ),
          ],
        ),
      ),
    );
  }
}
