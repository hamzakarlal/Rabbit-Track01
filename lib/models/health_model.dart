import 'package:cloud_firestore/cloud_firestore.dart';

enum HealthStatus { healthy, sick, underTreatment, recovered, critical }

extension HealthStatusExtension on HealthStatus {
  String get displayName {
    switch (this) {
      case HealthStatus.healthy:
        return 'Healthy';
      case HealthStatus.sick:
        return 'Sick';
      case HealthStatus.underTreatment:
        return 'Under Treatment';
      case HealthStatus.recovered:
        return 'Recovered';
      case HealthStatus.critical:
        return 'Critical';
    }
  }

  String get value => name;
}

class HealthRecordModel {
  final String id;
  final String farmId;
  final String rabbitId;
  final String rabbitTag;
  final DateTime date;
  final String? symptoms;
  final String? diagnosis;
  final String? treatment;
  final String? medicine;
  final String? dosage;
  final String? veterinarian;
  final DateTime? treatmentStartDate;
  final DateTime? treatmentEndDate;
  final HealthStatus status;
  final double? cost;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HealthRecordModel({
    required this.id,
    required this.farmId,
    required this.rabbitId,
    required this.rabbitTag,
    required this.date,
    this.symptoms,
    this.diagnosis,
    this.treatment,
    this.medicine,
    this.dosage,
    this.veterinarian,
    this.treatmentStartDate,
    this.treatmentEndDate,
    required this.status,
    this.cost,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOngoing =>
      status == HealthStatus.sick ||
      status == HealthStatus.underTreatment ||
      status == HealthStatus.critical;

  factory HealthRecordModel.fromMap(Map<String, dynamic> map, String id) {
    return HealthRecordModel(
      id: id,
      farmId: map['farmId'] ?? '',
      rabbitId: map['rabbitId'] ?? '',
      rabbitTag: map['rabbitTag'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      symptoms: map['symptoms'],
      diagnosis: map['diagnosis'],
      treatment: map['treatment'],
      medicine: map['medicine'],
      dosage: map['dosage'],
      veterinarian: map['veterinarian'],
      treatmentStartDate: (map['treatmentStartDate'] as Timestamp?)?.toDate(),
      treatmentEndDate: (map['treatmentEndDate'] as Timestamp?)?.toDate(),
      status: HealthStatus.values.firstWhere(
        (s) => s.value == map['status'],
        orElse: () => HealthStatus.sick,
      ),
      cost: (map['cost'] as num?)?.toDouble(),
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmId': farmId,
      'rabbitId': rabbitId,
      'rabbitTag': rabbitTag,
      'date': Timestamp.fromDate(date),
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'medicine': medicine,
      'dosage': dosage,
      'veterinarian': veterinarian,
      'treatmentStartDate': treatmentStartDate == null
          ? null
          : Timestamp.fromDate(treatmentStartDate!),
      'treatmentEndDate': treatmentEndDate == null
          ? null
          : Timestamp.fromDate(treatmentEndDate!),
      'status': status.value,
      'cost': cost,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  HealthRecordModel copyWith({
    String? symptoms,
    String? diagnosis,
    String? treatment,
    String? medicine,
    String? dosage,
    String? veterinarian,
    DateTime? treatmentStartDate,
    DateTime? treatmentEndDate,
    HealthStatus? status,
    double? cost,
    String? notes,
    DateTime? updatedAt,
  }) {
    return HealthRecordModel(
      id: id,
      farmId: farmId,
      rabbitId: rabbitId,
      rabbitTag: rabbitTag,
      date: date,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      medicine: medicine ?? this.medicine,
      dosage: dosage ?? this.dosage,
      veterinarian: veterinarian ?? this.veterinarian,
      treatmentStartDate: treatmentStartDate ?? this.treatmentStartDate,
      treatmentEndDate: treatmentEndDate ?? this.treatmentEndDate,
      status: status ?? this.status,
      cost: cost ?? this.cost,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class VaccinationModel {
  final String id;
  final String farmId;
  final String rabbitId;
  final String rabbitTag;
  final String vaccineName;
  final DateTime dateAdministered;
  final DateTime nextVaccinationDate;
  final String? dose;
  final String? veterinarian;
  final String? batchNumber;
  final double? cost;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VaccinationModel({
    required this.id,
    required this.farmId,
    required this.rabbitId,
    required this.rabbitTag,
    required this.vaccineName,
    required this.dateAdministered,
    required this.nextVaccinationDate,
    this.dose,
    this.veterinarian,
    this.batchNumber,
    this.cost,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isDue =>
      DateTime.now().isAfter(nextVaccinationDate) ||
      DateTime.now().isAtSameMomentAs(nextVaccinationDate);

  bool get isDueSoon {
    final diff = nextVaccinationDate.difference(DateTime.now()).inDays;
    return diff >= 0 && diff <= 7;
  }

  bool get isOverdue => DateTime.now().isAfter(nextVaccinationDate);

  factory VaccinationModel.fromMap(Map<String, dynamic> map, String id) {
    return VaccinationModel(
      id: id,
      farmId: map['farmId'] ?? '',
      rabbitId: map['rabbitId'] ?? '',
      rabbitTag: map['rabbitTag'] ?? '',
      vaccineName: map['vaccineName'] ?? '',
      dateAdministered:
          (map['dateAdministered'] as Timestamp?)?.toDate() ?? DateTime.now(),
      nextVaccinationDate:
          (map['nextVaccinationDate'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      dose: map['dose'],
      veterinarian: map['veterinarian'],
      batchNumber: map['batchNumber'],
      cost: (map['cost'] as num?)?.toDouble(),
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmId': farmId,
      'rabbitId': rabbitId,
      'rabbitTag': rabbitTag,
      'vaccineName': vaccineName,
      'dateAdministered': Timestamp.fromDate(dateAdministered),
      'nextVaccinationDate': Timestamp.fromDate(nextVaccinationDate),
      'dose': dose,
      'veterinarian': veterinarian,
      'batchNumber': batchNumber,
      'cost': cost,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  VaccinationModel copyWith({
    String? vaccineName,
    DateTime? dateAdministered,
    DateTime? nextVaccinationDate,
    String? dose,
    String? veterinarian,
    String? batchNumber,
    double? cost,
    String? notes,
    DateTime? updatedAt,
  }) {
    return VaccinationModel(
      id: id,
      farmId: farmId,
      rabbitId: rabbitId,
      rabbitTag: rabbitTag,
      vaccineName: vaccineName ?? this.vaccineName,
      dateAdministered: dateAdministered ?? this.dateAdministered,
      nextVaccinationDate: nextVaccinationDate ?? this.nextVaccinationDate,
      dose: dose ?? this.dose,
      veterinarian: veterinarian ?? this.veterinarian,
      batchNumber: batchNumber ?? this.batchNumber,
      cost: cost ?? this.cost,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
