import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/rabbit_model.dart';
import '../core/constants/app_constants.dart';

class RabbitRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String farmId) =>
      _firestore
          .collection(AppConstants.farmsCollection)
          .doc(farmId)
          .collection(AppConstants.rabbitsCollection);

  Future<String> addRabbit(RabbitModel rabbit) async {
    final doc = await _collection(rabbit.farmId).add(rabbit.toMap());
    return doc.id;
  }

  Future<void> updateRabbit(RabbitModel rabbit) async {
    await _collection(rabbit.farmId)
        .doc(rabbit.id)
        .update({...rabbit.toMap(), 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> deleteRabbit(String farmId, String rabbitId) async {
    await _collection(farmId).doc(rabbitId).delete();
  }

  Future<RabbitModel?> getRabbit(String farmId, String rabbitId) async {
    final doc = await _collection(farmId).doc(rabbitId).get();
    if (!doc.exists) return null;
    return RabbitModel.fromMap(doc.data()!, doc.id);
  }

  Stream<List<RabbitModel>> rabbitsStream(String farmId) {
    return _collection(farmId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => RabbitModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Stream<List<RabbitModel>> rabbitsStreamByStatus(
    String farmId,
    RabbitStatus status,
  ) {
    return _collection(farmId)
        .where('status', isEqualTo: status.value)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => RabbitModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Stream<List<RabbitModel>> rabbitsStreamByGender(
    String farmId,
    RabbitGender gender,
  ) {
    return _collection(farmId)
        .where('gender', isEqualTo: gender.value)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => RabbitModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<List<RabbitModel>> getAvailableBucks(String farmId) async {
    final snap = await _collection(farmId)
        .where('gender', isEqualTo: 'male')
        .where('status', isEqualTo: 'active')
        .get();
    return snap.docs.map((d) => RabbitModel.fromMap(d.data(), d.id)).toList();
  }

  Future<List<RabbitModel>> getAvailableDoes(String farmId) async {
    final snap = await _collection(farmId)
        .where('gender', isEqualTo: 'female')
        .where('status', isEqualTo: 'active')
        .get();
    return snap.docs.map((d) => RabbitModel.fromMap(d.data(), d.id)).toList();
  }

  Future<List<RabbitModel>> getAllRabbits(String farmId) async {
    final snap = await _collection(farmId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => RabbitModel.fromMap(d.data(), d.id)).toList();
  }

  Future<bool> tagExists(
    String farmId,
    String earTag, {
    String? excludeId,
  }) async {
    var query = _collection(farmId).where('earTag', isEqualTo: earTag);
    final snap = await query.get();
    if (excludeId != null) {
      return snap.docs.any((d) => d.id != excludeId);
    }
    return snap.docs.isNotEmpty;
  }

  Future<void> updateStatus(
    String farmId,
    String rabbitId,
    RabbitStatus status,
  ) async {
    await _collection(farmId).doc(rabbitId).update({
      'status': status.value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<int> getRabbitCount(String farmId) async {
    final snap = await _collection(farmId).count().get();
    return snap.count ?? 0;
  }
}
