import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

class FarmRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.farmsCollection);

  Future<FarmModel> createFarm({
    required String ownerId,
    required String farmName,
    required String location,
    String? description,
    String? contactNumber,
  }) async {
    final now = DateTime.now();
    final farm = FarmModel(
      id: '',
      ownerId: ownerId,
      farmName: farmName,
      location: location,
      description: description,
      contactNumber: contactNumber,
      createdAt: now,
      updatedAt: now,
    );

    final doc = await _collection.add(farm.toMap());
    return farm.copyWith(id: doc.id);
  }

  Future<FarmModel?> getFarm(String farmId) async {
    final doc = await _collection.doc(farmId).get();
    if (!doc.exists) return null;
    return FarmModel.fromMap(doc.data()!, farmId);
  }

  Stream<FarmModel?> farmStream(String farmId) {
    return _collection
        .doc(farmId)
        .snapshots()
        .map(
          (doc) => doc.exists ? FarmModel.fromMap(doc.data()!, farmId) : null,
        );
  }

  Future<void> updateFarm(FarmModel farm) async {
    await _collection.doc(farm.id).set({
      ...farm.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
