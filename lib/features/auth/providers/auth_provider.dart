
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/farm_repository.dart';

// ── Repositories ───────────────────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final farmRepositoryProvider = Provider<FarmRepository>(
  (ref) => FarmRepository(),
);

// ── Auth State ─────────────────────────────────────────────────────────────────
final authStateProvider = StreamProvider<String?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// ── Current User Data ──────────────────────────────────────────────────────────
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  final authRepo = ref.watch(authRepositoryProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return authRepo.userStream(user);
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

// ── Current Farm ID ────────────────────────────────────────────────────────────
final currentFarmIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  return user?.farmId;
});

// ── Current Farm ───────────────────────────────────────────────────────────────
final currentFarmProvider = StreamProvider<FarmModel?>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  final farmRepo = ref.watch(farmRepositoryProvider);

  if (farmId == null || farmId.isEmpty) return Stream.value(null);
  return farmRepo.farmStream(farmId);
});

// ── Auth Notifier ──────────────────────────────────────────────────────────────
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepo;
  final FarmRepository _farmRepo;

  AuthNotifier(this._authRepo, this._farmRepo) : super(const AsyncValue.data(null));

  Future<bool> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      await _authRepo.signIn(email: email, password: password);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }



  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String farmName,
    required String location,
    String? description,
    String? contactNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      final userId = await _authRepo.register(
        email: email,
        password: password,
      );

      // Create farm first
      final farm = await _farmRepo.createFarm(
        ownerId: userId,
        farmName: farmName,
        location: location,
        description: description,
        contactNumber: contactNumber ?? phoneNumber,
      );
      final farmId = farm.id;

      // Create user document
      await _authRepo.createUserDocument(
        userId: userId,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        farmId: farmId,
      );

      // Send verification email (ignore errors if it fails)
      try {
        await _authRepo.sendEmailVerification();
      } catch (e) {
        debugPrint('Email verification failed: $e');
      }

      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> setupFarm({
    required String farmName,
    required String location,
    String? description,
    String? contactNumber,
    required String userId,
    required String phoneNumber,
    required String fullName,
    required String email,
  }) async {
    state = const AsyncValue.loading();
    try {
      final farm = await _farmRepo.createFarm(
        ownerId: userId,
        farmName: farmName,
        location: location,
        description: description,
        contactNumber: contactNumber,
      );
      final farmId = farm.id;

      await _authRepo.createUserDocument(
        userId: userId,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        farmId: farmId,
      );

      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncValue.loading();
    try {
      await _authRepo.sendPasswordResetEmail(email);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(farmRepositoryProvider),
  );
});
