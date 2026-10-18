import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/breeding_model.dart';
import '../models/health_model.dart';
import '../models/feeding_model.dart';
import '../models/sale_model.dart';
import '../models/inventory_model.dart';
import '../repositories/breeding_repository.dart';
import '../repositories/health_repository.dart';
import '../repositories/farm_data_repository.dart';
import '../features/auth/providers/auth_provider.dart';

// ── Repository Providers ────────────────────────────────────────────────────────
final breedingRepositoryProvider = Provider<BreedingRepository>(
    (ref) => BreedingRepository());
final healthRepositoryProvider = Provider<HealthRepository>(
    (ref) => HealthRepository());
final feedingRepositoryProvider = Provider<FeedingRepository>(
    (ref) => FeedingRepository());
final expenseRepositoryProvider = Provider<ExpenseRepository>(
    (ref) => ExpenseRepository());
final inventoryRepositoryProvider = Provider<InventoryRepository>(
    (ref) => InventoryRepository());
final saleRepositoryProvider = Provider<SaleRepository>(
    (ref) => SaleRepository());
final notificationRepositoryProvider = Provider<NotificationRepository>(
    (ref) => NotificationRepository());

// ── Stream Providers ────────────────────────────────────────────────────────────
final breedingsStreamProvider = StreamProvider<List<BreedingModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(breedingRepositoryProvider).breedingStream(farmId);
});

final activeBreedingsStreamProvider =
    StreamProvider<List<BreedingModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(breedingRepositoryProvider).activeBreedingsStream(farmId);
});

final kindlingsStreamProvider = StreamProvider<List<KindlingModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(breedingRepositoryProvider).kindlingStream(farmId);
});

final healthRecordsStreamProvider =
    StreamProvider<List<HealthRecordModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(healthRepositoryProvider).healthRecordsStream(farmId);
});

final activeHealthRecordsStreamProvider =
    StreamProvider<List<HealthRecordModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref
      .watch(healthRepositoryProvider)
      .activeHealthRecordsStream(farmId);
});

final vaccinationsStreamProvider =
    StreamProvider<List<VaccinationModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(healthRepositoryProvider).vaccinationsStream(farmId);
});

final upcomingVaccinationsStreamProvider =
    StreamProvider<List<VaccinationModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref
      .watch(healthRepositoryProvider)
      .upcomingVaccinationsStream(farmId);
});

final feedingStreamProvider = StreamProvider<List<FeedingModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(feedingRepositoryProvider).feedingStream(farmId);
});

final expensesStreamProvider = StreamProvider<List<ExpenseModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(expenseRepositoryProvider).expensesStream(farmId);
});

final inventoryStreamProvider =
    StreamProvider<List<InventoryItemModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(inventoryRepositoryProvider).inventoryStream(farmId);
});

final salesStreamProvider = StreamProvider<List<SaleModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(saleRepositoryProvider).salesStream(farmId);
});

final notificationsStreamProvider =
    StreamProvider<List<NotificationModel>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value([]);
  return ref.watch(notificationRepositoryProvider).notificationsStream(farmId);
});

final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final farmId = ref.watch(currentFarmIdProvider);
  if (farmId == null) return Stream.value(0);
  return ref
      .watch(notificationRepositoryProvider)
      .unreadCountStream(farmId);
});

// ── Notifiers ────────────────────────────────────────────────────────────────────
class BreedingNotifier extends StateNotifier<AsyncValue<void>> {
  final BreedingRepository _repo;
  final String farmId;

  BreedingNotifier(this._repo, this.farmId)
      : super(const AsyncValue.data(null));

  Future<String?> addBreeding(BreedingModel breeding) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addBreeding(breeding);
      state = const AsyncValue.data(null);
      return id;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> updateBreeding(BreedingModel breeding) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateBreeding(breeding);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteBreeding(String breedingId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteBreeding(farmId, breedingId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<String?> addKindling(KindlingModel kindling) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addKindling(kindling);
      state = const AsyncValue.data(null);
      return id;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> deleteKindling(String kindlingId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteKindling(farmId, kindlingId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

final breedingNotifierProvider =
    StateNotifierProvider<BreedingNotifier, AsyncValue<void>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider) ?? '';
  return BreedingNotifier(ref.watch(breedingRepositoryProvider), farmId);
});

class HealthNotifier extends StateNotifier<AsyncValue<void>> {
  final HealthRepository _repo;
  final String farmId;

  HealthNotifier(this._repo, this.farmId) : super(const AsyncValue.data(null));

  Future<String?> addHealthRecord(HealthRecordModel record) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addHealthRecord(record);
      state = const AsyncValue.data(null);
      return id;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> updateHealthRecord(HealthRecordModel record) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateHealthRecord(record);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteHealthRecord(String recordId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteHealthRecord(farmId, recordId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<String?> addVaccination(VaccinationModel vaccination) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addVaccination(vaccination);
      state = const AsyncValue.data(null);
      return id;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> deleteVaccination(String vaccinationId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteVaccination(farmId, vaccinationId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

final healthNotifierProvider =
    StateNotifierProvider<HealthNotifier, AsyncValue<void>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider) ?? '';
  return HealthNotifier(ref.watch(healthRepositoryProvider), farmId);
});

class FeedingNotifier extends StateNotifier<AsyncValue<void>> {
  final FeedingRepository _repo;
  final String farmId;

  FeedingNotifier(this._repo, this.farmId)
      : super(const AsyncValue.data(null));

  Future<String?> addFeeding(FeedingModel feeding) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addFeeding(feeding);
      state = const AsyncValue.data(null);
      return id;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> deleteFeeding(String feedingId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteFeeding(farmId, feedingId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

final feedingNotifierProvider =
    StateNotifierProvider<FeedingNotifier, AsyncValue<void>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider) ?? '';
  return FeedingNotifier(ref.watch(feedingRepositoryProvider), farmId);
});

class ExpenseNotifier extends StateNotifier<AsyncValue<void>> {
  final ExpenseRepository _repo;
  final String farmId;

  ExpenseNotifier(this._repo, this.farmId) : super(const AsyncValue.data(null));

  Future<String?> addExpense(ExpenseModel expense) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addExpense(expense);
      state = const AsyncValue.data(null);
      return id;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> deleteExpense(String expenseId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteExpense(farmId, expenseId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

final expenseNotifierProvider =
    StateNotifierProvider<ExpenseNotifier, AsyncValue<void>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider) ?? '';
  return ExpenseNotifier(ref.watch(expenseRepositoryProvider), farmId);
});

class InventoryNotifier extends StateNotifier<AsyncValue<void>> {
  final InventoryRepository _repo;
  final String farmId;

  InventoryNotifier(this._repo, this.farmId)
      : super(const AsyncValue.data(null));

  Future<String?> addItem(InventoryItemModel item) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addItem(item);
      state = const AsyncValue.data(null);
      return id;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> updateItem(InventoryItemModel item) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateItem(item);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteItem(String itemId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteItem(farmId, itemId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> adjustQuantity(String itemId, double adjustment) async {
    try {
      await _repo.adjustQuantity(farmId, itemId, adjustment);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final inventoryNotifierProvider =
    StateNotifierProvider<InventoryNotifier, AsyncValue<void>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider) ?? '';
  return InventoryNotifier(ref.watch(inventoryRepositoryProvider), farmId);
});

class SaleNotifier extends StateNotifier<AsyncValue<void>> {
  final SaleRepository _repo;
  final String farmId;

  SaleNotifier(this._repo, this.farmId) : super(const AsyncValue.data(null));

  Future<String?> addSale(SaleModel sale) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addSale(sale);
      state = const AsyncValue.data(null);
      return id;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> deleteSale(String saleId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteSale(farmId, saleId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

final saleNotifierProvider =
    StateNotifierProvider<SaleNotifier, AsyncValue<void>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider) ?? '';
  return SaleNotifier(ref.watch(saleRepositoryProvider), farmId);
});

class NotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final NotificationRepository _repo;
  final String farmId;

  NotificationNotifier(this._repo, this.farmId)
      : super(const AsyncValue.data(null));

  Future<void> markAsRead(String notificationId) async {
    await _repo.markAsRead(farmId, notificationId);
  }

  Future<void> markAllAsRead() async {
    await _repo.markAllAsRead(farmId);
  }

  Future<void> deleteNotification(String notificationId) async {
    await _repo.deleteNotification(farmId, notificationId);
  }

  Future<void> addNotification(NotificationModel notification) async {
    await _repo.addNotification(notification);
  }
}

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<void>>((ref) {
  final farmId = ref.watch(currentFarmIdProvider) ?? '';
  return NotificationNotifier(
      ref.watch(notificationRepositoryProvider), farmId);
});
