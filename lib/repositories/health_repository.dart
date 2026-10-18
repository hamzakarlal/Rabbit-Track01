import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/health_model.dart';
import '../core/constants/app_constants.dart';

class HealthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _healthCollection(String farmId) =>
      _firestore
          .collection(AppConstants.farmsCollection)
          .doc(farmId)
          .collection(AppConstants.healthRecordsCollection);

  CollectionReference<Map<String, dynamic>> _vaccinationCollection(
    String farmId,
  ) => _firestore
      .collection(AppConstants.farmsCollection)
      .doc(farmId)
      .collection(AppConstants.vaccinationsCollection);

  // ── Health Records ────────────────────────────────────────────────────
  Future<String> addHealthRecord(HealthRecordModel record) async {
    final doc = await _healthCollection(record.farmId).add(record.toMap());
    return doc.id;
  }

  Future<void> updateHealthRecord(HealthRecordModel record) async {
    await _healthCollection(record.farmId)
        .doc(record.id)
        .update({...record.toMap(), 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> deleteHealthRecord(String farmId, String recordId) async {
    await _healthCollection(farmId).doc(recordId).delete();
  }

  Stream<List<HealthRecordModel>> healthRecordsStream(String farmId) {
    return _healthCollection(farmId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => HealthRecordModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Stream<List<HealthRecordModel>> activeHealthRecordsStream(String farmId) {
    return _healthCollection(farmId)
        .where('status', whereIn: ['sick', 'underTreatment', 'critical'])
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => HealthRecordModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<List<HealthRecordModel>> getHealthRecordsForRabbit(
    String farmId,
    String rabbitId,
  ) async {
    final snap = await _healthCollection(farmId)
        .where('rabbitId', isEqualTo: rabbitId)
        .orderBy('date', descending: true)
        .get();
    return snap.docs
        .map((d) => HealthRecordModel.fromMap(d.data(), d.id))
        .toList();
  }

  // ── Vaccinations ──────────────────────────────────────────────────────
  Future<String> addVaccination(VaccinationModel vaccination) async {
    final doc = await _vaccinationCollection(vaccination.farmId)
        .add(vaccination.toMap());
    return doc.id;
  }

  Future<void> updateVaccination(VaccinationModel vaccination) async {
    await _vaccinationCollection(vaccination.farmId).doc(vaccination.id).update(
      {...vaccination.toMap(), 'updatedAt': FieldValue.serverTimestamp()},
    );
  }

  Future<void> deleteVaccination(String farmId, String vaccinationId) async {
    await _vaccinationCollection(farmId).doc(vaccinationId).delete();
  }

  Stream<List<VaccinationModel>> vaccinationsStream(String farmId) {
    return _vaccinationCollection(farmId)
        .orderBy('nextVaccinationDate')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => VaccinationModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Stream<List<VaccinationModel>> upcomingVaccinationsStream(String farmId) {
    final now = Timestamp.fromDate(DateTime.now());
    final inSevenDays = Timestamp.fromDate(
      DateTime.now().add(const Duration(days: 7)),
    );
    return _vaccinationCollection(farmId)
        .where('nextVaccinationDate', isGreaterThanOrEqualTo: now)
        .where('nextVaccinationDate', isLessThanOrEqualTo: inSevenDays)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => VaccinationModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<List<VaccinationModel>> getVaccinationsForRabbit(
    String farmId,
    String rabbitId,
  ) async {
    final snap = await _vaccinationCollection(farmId)
        .where('rabbitId', isEqualTo: rabbitId)
        .orderBy('dateAdministered', descending: true)
        .get();
    return snap.docs
        .map((d) => VaccinationModel.fromMap(d.data(), d.id))
        .toList();
  }
}
