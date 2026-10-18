import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rabbit_model.dart';
import '../repositories/rabbit_repository.dart';
import '../features/auth/providers/auth_provider.dart';

final rabbitRepositoryProvider = Provider<RabbitRepository>(
  (ref) => RabbitRepository(),
);

final rabbitsStreamProvider = StreamProvider<List<RabbitModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(rabbitRepositoryProvider).rabbitsStream(farmId);
});

final rabbitProvider =
    FutureProvider.family<RabbitModel?, String>((ref, rabbitId) async {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return null;
  return ref.watch(rabbitRepositoryProvider).getRabbit(farmId, rabbitId);
});

// ── Rabbit Notifier ──────────────────────────────────────────────────────────
class RabbitNotifier extends StateNotifier<AsyncValue<void>> {
  final RabbitRepository _repo;
  final String farmId;

  RabbitNotifier(this._repo, this.farmId)
      : super(const AsyncValue.data(null));

  Future<String?> addRabbit(RabbitModel rabbit) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addRabbit(rabbit);
      state = const AsyncValue.data(null);
      return id;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> updateRabbit(RabbitModel rabbit) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateRabbit(rabbit);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteRabbit(String rabbitId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteRabbit(farmId, rabbitId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateStatus(String rabbitId, RabbitStatus status) async {
    try {
      await _repo.updateStatus(farmId, rabbitId, status);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> tagExists(String earTag, {String? excludeId}) async {
    return _repo.tagExists(farmId, earTag, excludeId: excludeId);
  }

  Future<int> getRabbitCount() async {
    return _repo.getRabbitCount(farmId);
  }
}

final rabbitNotifierProvider =
    StateNotifierProvider<RabbitNotifier, AsyncValue<void>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider) ?? '';
  return RabbitNotifier(ref.watch(rabbitRepositoryProvider), farmId);
});

// Convenience aliases
final rabbitDetailProvider = rabbitProvider;
final rabbitCrudProvider = rabbitNotifierProvider;
