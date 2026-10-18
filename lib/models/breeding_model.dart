import 'package:cloud_firestore/cloud_firestore.dart';

enum BreedingStatus { active, successful, failed, cancelled }

extension BreedingStatusExtension on BreedingStatus {
  String get displayName {
    switch (this) {
      case BreedingStatus.active:
        return 'Active (Pregnant)';
      case BreedingStatus.successful:
        return 'Successful';
      case BreedingStatus.failed:
        return 'Failed';
      case BreedingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get value => name;
}

class BreedingModel {
  final String id;
  final String farmId;
  final String buckId;
  final String buckTag;
  final String doeId;
  final String doeTag;
  final DateTime breedingDate;
  final DateTime expectedKindlingDate;
  final DateTime? actualKindlingDate;
  final BreedingStatus status;
  final int numberOfAttempts;
  final String? breedingMethod;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BreedingModel({
    required this.id,
    required this.farmId,
    required this.buckId,
    required this.buckTag,
    required this.doeId,
    required this.doeTag,
    required this.breedingDate,
    required this.expectedKindlingDate,
    this.actualKindlingDate,
    required this.status,
    required this.numberOfAttempts,
    this.breedingMethod,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Rabbits gestation period is approximately 31 days
  static DateTime calculateExpectedKindling(DateTime breedingDate) {
    return breedingDate.add(const Duration(days: 31));
  }

  int get daysUntilKindling {
    if (status != BreedingStatus.active) return 0;
    return expectedKindlingDate.difference(DateTime.now()).inDays;
  }

  bool get isOverdue =>
      status == BreedingStatus.active &&
      DateTime.now().isAfter(expectedKindlingDate);

  factory BreedingModel.fromMap(Map<String, dynamic> map, String id) {
    return BreedingModel(
      id: id,
      farmId: map['farmId'] ?? '',
      buckId: map['buckId'] ?? '',
      buckTag: map['buckTag'] ?? '',
      doeId: map['doeId'] ?? '',
      doeTag: map['doeTag'] ?? '',
      breedingDate:
          (map['breedingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expectedKindlingDate:
          (map['expectedKindlingDate'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      actualKindlingDate: (map['actualKindlingDate'] as Timestamp?)?.toDate(),
      status: BreedingStatus.values.firstWhere(
        (s) => s.value == map['status'],
        orElse: () => BreedingStatus.active,
      ),
      numberOfAttempts: map['numberOfAttempts'] ?? 1,
      breedingMethod: map['breedingMethod'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmId': farmId,
      'buckId': buckId,
      'buckTag': buckTag,
      'doeId': doeId,
      'doeTag': doeTag,
      'breedingDate': Timestamp.fromDate(breedingDate),
      'expectedKindlingDate': Timestamp.fromDate(expectedKindlingDate),
      'actualKindlingDate': actualKindlingDate == null
          ? null
          : Timestamp.fromDate(actualKindlingDate!),
      'status': status.value,
      'numberOfAttempts': numberOfAttempts,
      'breedingMethod': breedingMethod,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  BreedingModel copyWith({
    DateTime? actualKindlingDate,
    BreedingStatus? status,
    int? numberOfAttempts,
    String? breedingMethod,
    String? notes,
    DateTime? updatedAt,
  }) {
    return BreedingModel(
      id: id,
      farmId: farmId,
      buckId: buckId,
      buckTag: buckTag,
      doeId: doeId,
      doeTag: doeTag,
      breedingDate: breedingDate,
      expectedKindlingDate: expectedKindlingDate,
      actualKindlingDate: actualKindlingDate ?? this.actualKindlingDate,
      status: status ?? this.status,
      numberOfAttempts: numberOfAttempts ?? this.numberOfAttempts,
      breedingMethod: breedingMethod ?? this.breedingMethod,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class KindlingModel {
  final String id;
  final String farmId;
  final String breedingId;
  final String doeId;
  final String doeTag;
  final String buckId;
  final String buckTag;
  final DateTime kindlingDate;
  final DateTime? expectedDate;
  final int totalKits;
  final int liveKits;
  final int stillbornKits;
  final int maleKits;
  final int femaleKits;
  final String? nestCondition;
  final String? motherCondition;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const KindlingModel({
    required this.id,
    required this.farmId,
    required this.breedingId,
    required this.doeId,
    required this.doeTag,
    required this.buckId,
    required this.buckTag,
    required this.kindlingDate,
    this.expectedDate,
    required this.totalKits,
    required this.liveKits,
    required this.stillbornKits,
    required this.maleKits,
    required this.femaleKits,
    this.nestCondition,
    this.motherCondition,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  double get survivalRate => totalKits > 0 ? (liveKits / totalKits) * 100 : 0;

  double get mortalityRate =>
      totalKits > 0 ? (stillbornKits / totalKits) * 100 : 0;

  factory KindlingModel.fromMap(Map<String, dynamic> map, String id) {
    return KindlingModel(
      id: id,
      farmId: map['farmId'] ?? '',
      breedingId: map['breedingId'] ?? '',
      doeId: map['doeId'] ?? '',
      doeTag: map['doeTag'] ?? '',
      buckId: map['buckId'] ?? '',
      buckTag: map['buckTag'] ?? '',
      kindlingDate:
          (map['kindlingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expectedDate: (map['expectedDate'] as Timestamp?)?.toDate(),
      totalKits: map['totalKits'] ?? 0,
      liveKits: map['liveKits'] ?? 0,
      stillbornKits: map['stillbornKits'] ?? 0,
      maleKits: map['maleKits'] ?? 0,
      femaleKits: map['femaleKits'] ?? 0,
      nestCondition: map['nestCondition'],
      motherCondition: map['motherCondition'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmId': farmId,
      'breedingId': breedingId,
      'doeId': doeId,
      'doeTag': doeTag,
      'buckId': buckId,
      'buckTag': buckTag,
      'kindlingDate': Timestamp.fromDate(kindlingDate),
      'expectedDate': expectedDate == null
          ? null
          : Timestamp.fromDate(expectedDate!),
      'totalKits': totalKits,
      'liveKits': liveKits,
      'stillbornKits': stillbornKits,
      'maleKits': maleKits,
      'femaleKits': femaleKits,
      'nestCondition': nestCondition,
      'motherCondition': motherCondition,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  KindlingModel copyWith({
    int? totalKits,
    int? liveKits,
    int? stillbornKits,
    int? maleKits,
    int? femaleKits,
    String? nestCondition,
    String? motherCondition,
    String? notes,
    DateTime? updatedAt,
  }) {
    return KindlingModel(
      id: id,
      farmId: farmId,
      breedingId: breedingId,
      doeId: doeId,
      doeTag: doeTag,
      buckId: buckId,
      buckTag: buckTag,
      kindlingDate: kindlingDate,
      expectedDate: expectedDate,
      totalKits: totalKits ?? this.totalKits,
      liveKits: liveKits ?? this.liveKits,
      stillbornKits: stillbornKits ?? this.stillbornKits,
      maleKits: maleKits ?? this.maleKits,
      femaleKits: femaleKits ?? this.femaleKits,
      nestCondition: nestCondition ?? this.nestCondition,
      motherCondition: motherCondition ?? this.motherCondition,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
