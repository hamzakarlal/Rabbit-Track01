import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/feeding_model.dart';
import '../models/sale_model.dart';
import '../models/inventory_model.dart';
import '../core/constants/app_constants.dart';

class FeedingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String farmId) =>
      _firestore
          .collection(AppConstants.farmsCollection)
          .doc(farmId)
          .collection(AppConstants.feedingCollection);

  Future<String> addFeeding(FeedingModel feeding) async {
    final doc = await _collection(feeding.farmId).add(feeding.toMap());
    return doc.id;
  }

  Future<void> updateFeeding(FeedingModel feeding) async {
    await _collection(feeding.farmId).doc(feeding.id).update({
      ...feeding.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteFeeding(String farmId, String feedingId) async {
    await _collection(farmId).doc(feedingId).delete();
  }

  Stream<List<FeedingModel>> feedingStream(String farmId) {
    return _collection(farmId)
        .orderBy('feedingDate', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => FeedingModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<double> getTotalFeedingCostForMonth(
    String farmId,
    DateTime month,
  ) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final snap = await _collection(farmId)
        .where('feedingDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('feedingDate', isLessThan: Timestamp.fromDate(end))
        .get();

    return snap.docs.fold<double>(0.0, (acc, doc) {
      final model = FeedingModel.fromMap(doc.data(), doc.id);
      return acc + model.totalCost;
    });
  }
}

class ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String farmId) =>
      _firestore
          .collection(AppConstants.farmsCollection)
          .doc(farmId)
          .collection(AppConstants.expensesCollection);

  Future<String> addExpense(ExpenseModel expense) async {
    final doc = await _collection(expense.farmId).add(expense.toMap());
    return doc.id;
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await _collection(expense.farmId).doc(expense.id).update({
      ...expense.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteExpense(String farmId, String expenseId) async {
    await _collection(farmId).doc(expenseId).delete();
  }

  Stream<List<ExpenseModel>> expensesStream(String farmId) {
    return _collection(farmId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ExpenseModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<double> getTotalExpensesForMonth(String farmId, DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final snap = await _collection(farmId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .get();

    return snap.docs.fold<double>(0.0, (acc, doc) {
      final model = ExpenseModel.fromMap(doc.data(), doc.id);
      return acc + model.amount;
    });
  }
}

class InventoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String farmId) =>
      _firestore
          .collection(AppConstants.farmsCollection)
          .doc(farmId)
          .collection(AppConstants.inventoryCollection);

  Future<String> addItem(InventoryItemModel item) async {
    final doc = await _collection(item.farmId).add(item.toMap());
    return doc.id;
  }

  Future<void> updateItem(InventoryItemModel item) async {
    await _collection(item.farmId)
        .doc(item.id)
        .update({...item.toMap(), 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> deleteItem(String farmId, String itemId) async {
    await _collection(farmId).doc(itemId).delete();
  }

  Stream<List<InventoryItemModel>> inventoryStream(String farmId) {
    return _collection(farmId)
        .orderBy('name')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => InventoryItemModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Stream<List<InventoryItemModel>> lowStockStream(String farmId) {
    return inventoryStream(farmId).map(
      (items) =>
          items.where((i) => i.stockStatus == StockStatus.lowStock).toList(),
    );
  }

  Future<void> adjustQuantity(
    String farmId,
    String itemId,
    double adjustment,
  ) async {
    await _collection(farmId).doc(itemId).update({
      'quantity': FieldValue.increment(adjustment),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

class SaleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String farmId) =>
      _firestore
          .collection(AppConstants.farmsCollection)
          .doc(farmId)
          .collection(AppConstants.salesCollection);

  Future<String> addSale(SaleModel sale) async {
    final doc = await _collection(sale.farmId).add(sale.toMap());
    return doc.id;
  }

  Future<void> updateSale(SaleModel sale) async {
    await _collection(sale.farmId)
        .doc(sale.id)
        .update({...sale.toMap(), 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> deleteSale(String farmId, String saleId) async {
    await _collection(farmId).doc(saleId).delete();
  }

  Future<SaleModel?> getSale(String farmId, String saleId) async {
    final doc = await _collection(farmId).doc(saleId).get();
    if (!doc.exists) return null;
    return SaleModel.fromMap(doc.data()!, doc.id);
  }

  Stream<List<SaleModel>> salesStream(String farmId) {
    return _collection(farmId)
        .orderBy('saleDate', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => SaleModel.fromMap(d.data(), d.id)).toList(),
        );
  }

  Future<double> getTotalRevenueForMonth(String farmId, DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final snap = await _collection(farmId)
        .where('saleDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('saleDate', isLessThan: Timestamp.fromDate(end))
        .get();

    return snap.docs.fold<double>(0.0, (acc, doc) {
      final model = SaleModel.fromMap(doc.data(), doc.id);
      return acc + model.totalPrice;
    });
  }
}

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String farmId) =>
      _firestore
          .collection(AppConstants.farmsCollection)
          .doc(farmId)
          .collection(AppConstants.notificationsCollection);

  Future<String> addNotification(NotificationModel notification) async {
    final doc = await _collection(notification.farmId)
        .add(notification.toMap());
    return doc.id;
  }

  Future<void> markAsRead(String farmId, String notificationId) async {
    await _collection(farmId).doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead(String farmId) async {
    final snap = await _collection(farmId)
        .where('isRead', isEqualTo: false)
        .get();
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.update(_collection(farmId).doc(doc.id), {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> deleteNotification(String farmId, String notificationId) async {
    await _collection(farmId).doc(notificationId).delete();
  }

  Stream<List<NotificationModel>> notificationsStream(String farmId) {
    return _collection(farmId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => NotificationModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Stream<int> unreadCountStream(String farmId) {
    return _collection(farmId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs.length);
  }
}
