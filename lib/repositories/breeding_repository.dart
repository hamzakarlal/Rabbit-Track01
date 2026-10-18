import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/breeding_model.dart';
import '../core/constants/app_constants.dart';

class BreedingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _breedingCollection(
    String farmId,
  ) => _firestore
      .collection(AppConstants.farmsCollection)
      .doc(farmId)
      .collection(AppConstants.breedingCollection);

  CollectionReference<Map<String, dynamic>> _kindlingCollection(
    String farmId,
  ) => _firestore
      .collection(AppConstants.farmsCollection)
      .doc(farmId)
      .collection(AppConstants.kindlingsCollection);

  // ── Breeding ──────────────────────────────────────────────────────────
  Future<String> addBreeding(BreedingModel breeding) async {
    final doc = await _breedingCollection(breeding.farmId)
        .add(breeding.toMap());
    return doc.id;
  }

  Future<void> updateBreeding(BreedingModel breeding) async {
    await _breedingCollection(breeding.farmId).doc(breeding.id).update({
      ...breeding.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteBreeding(String farmId, String breedingId) async {
    await _breedingCollection(farmId).doc(breedingId).delete();
  }

  Future<BreedingModel?> getBreeding(String farmId, String breedingId) async {
    final doc = await _breedingCollection(farmId).doc(breedingId).get();
    if (!doc.exists) return null;
    return BreedingModel.fromMap(doc.data()!, doc.id);
  }

  Stream<List<BreedingModel>> breedingStream(String farmId) {
    return _breedingCollection(farmId)
        .orderBy('breedingDate', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => BreedingModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Stream<List<BreedingModel>> activeBreedingsStream(String farmId) {
    return _breedingCollection(farmId)
        .where('status', isEqualTo: 'active')
        .orderBy('expectedKindlingDate')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => BreedingModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<List<BreedingModel>> getBreedingsForRabbit(
    String farmId,
    String rabbitId,
  ) async {
    final buck = await _breedingCollection(farmId)
        .where('buckId', isEqualTo: rabbitId)
        .get();
    final doe = await _breedingCollection(farmId)
        .where('doeId', isEqualTo: rabbitId)
        .get();

    final breedings = <BreedingModel>[];
    for (final doc in [...buck.docs, ...doe.docs]) {
      breedings.add(BreedingModel.fromMap(doc.data(), doc.id));
    }
    breedings.sort((a, b) => b.breedingDate.compareTo(a.breedingDate));
    return breedings;
  }

  // ── Kindling ──────────────────────────────────────────────────────────
  Future<String> addKindling(KindlingModel kindling) async {
    final doc = await _kindlingCollection(kindling.farmId)
        .add(kindling.toMap());
    return doc.id;
  }

  Future<void> updateKindling(KindlingModel kindling) async {
    await _kindlingCollection(kindling.farmId).doc(kindling.id).update({
      ...kindling.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteKindling(String farmId, String kindlingId) async {
    await _kindlingCollection(farmId).doc(kindlingId).delete();
  }

  Stream<List<KindlingModel>> kindlingStream(String farmId) {
    return _kindlingCollection(farmId)
        .orderBy('kindlingDate', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => KindlingModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<List<KindlingModel>> getKindlingsForRabbit(
    String farmId,
    String rabbitId,
  ) async {
    final snap = await _kindlingCollection(farmId)
        .where('doeId', isEqualTo: rabbitId)
        .get();
    return snap.docs.map((d) => KindlingModel.fromMap(d.data(), d.id)).toList();
  }
}
