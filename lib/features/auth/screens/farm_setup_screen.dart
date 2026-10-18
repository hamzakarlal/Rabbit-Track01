import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/auth/providers/auth_provider.dart';

class FarmSetupScreen extends ConsumerStatefulWidget {
  const FarmSetupScreen({super.key});

  @override
  ConsumerState<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends ConsumerState<FarmSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmNameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _farmNameCtrl.dispose();
    _locationCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final userId = ref.read(authStateProvider).valueOrNull;
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }
    final currentUser = ref.read(currentUserProvider).valueOrNull;
    
    final success = await ref.read(authNotifierProvider.notifier).setupFarm(
          farmName: _farmNameCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          userId: userId,
          phoneNumber: currentUser?.phoneNumber ?? '',
          fullName: currentUser?.fullName ?? '',
          email: currentUser?.email ?? '',
        );
    if (mounted) {
      setState(() => _loading = false);
      if (success) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text('Setup Your Farm', style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Text('Tell us about your rabbit farm to get started.',
                    style: AppTextStyles.bodyMedium),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _farmNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Farm Name',
                    prefixIcon: Icon(Icons.home_work_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter farm name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter location' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Create Farm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
