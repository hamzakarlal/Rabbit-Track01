import 'package:cloud_firestore/cloud_firestore.dart';

enum RabbitGender { male, female }

enum RabbitStatus { active, breeding, pregnant, sick, sold, deceased, retired }

extension RabbitGenderExtension on RabbitGender {
  String get displayName =>
      this == RabbitGender.male ? 'Buck (Male)' : 'Doe (Female)';
  String get shortName => this == RabbitGender.male ? 'Buck' : 'Doe';
  String get value => this == RabbitGender.male ? 'male' : 'female';
}

extension RabbitStatusExtension on RabbitStatus {
  String get displayName {
    switch (this) {
      case RabbitStatus.active:
        return 'Active';
      case RabbitStatus.breeding:
        return 'Breeding';
      case RabbitStatus.pregnant:
        return 'Pregnant';
      case RabbitStatus.sick:
        return 'Sick';
      case RabbitStatus.sold:
        return 'Sold';
      case RabbitStatus.deceased:
        return 'Deceased';
      case RabbitStatus.retired:
        return 'Retired';
    }
  }

  String get value => name;
}

class RabbitModel {
  final String id;
  final String farmId;
  final String earTag;
  final String? name;
  final RabbitGender gender;
  final String breed;
  final String? color;
  final DateTime dateOfBirth;
  final double? weight;
  final RabbitStatus status;
  final String? photoUrl;
  final String? cageNumber;
  final String? farmSection;
  final String? fatherId;
  final String? motherId;
  final String? fatherTag;
  final String? motherTag;
  final DateTime? purchaseDate;
  final double? purchaseCost;
  final String? source;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RabbitModel({
    required this.id,
    required this.farmId,
    required this.earTag,
    this.name,
    required this.gender,
    required this.breed,
    this.color,
    required this.dateOfBirth,
    this.weight,
    required this.status,
    this.photoUrl,
    this.cageNumber,
    this.farmSection,
    this.fatherId,
    this.motherId,
    this.fatherTag,
    this.motherTag,
    this.purchaseDate,
    this.purchaseCost,
    this.source,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayName => name ?? earTag;

  int get ageInDays => DateTime.now().difference(dateOfBirth).inDays;

  int get ageInMonths =>
      (DateTime.now().difference(dateOfBirth).inDays / 30.44).floor();

  String get ageDisplay {
    final months = ageInMonths;
    if (months < 1) return '${ageInDays}d';
    if (months < 12) return '${months}mo';
    final years = (months / 12).floor();
    final rem = months % 12;
    return rem == 0 ? '${years}yr' : '${years}yr ${rem}mo';
  }

  bool get isKit => ageInDays < 90;
  bool get isAvailableForBreeding => gender == RabbitGender.male
      ? status == RabbitStatus.active && ageInDays >= 120
      : status == RabbitStatus.active && ageInDays >= 150;

  factory RabbitModel.fromMap(Map<String, dynamic> map, String id) {
    return RabbitModel(
      id: id,
      farmId: map['farmId'] ?? '',
      earTag: map['earTag'] ?? '',
      name: map['name'],
      gender: map['gender'] == 'female'
          ? RabbitGender.female
          : RabbitGender.male,
      breed: map['breed'] ?? '',
      color: map['color'],
      dateOfBirth:
          (map['dateOfBirth'] as Timestamp?)?.toDate() ?? DateTime.now(),
      weight: (map['weight'] as num?)?.toDouble(),
      status: RabbitStatus.values.firstWhere(
        (s) => s.value == map['status'],
        orElse: () => RabbitStatus.active,
      ),
      photoUrl: map['photoUrl'],
      cageNumber: map['cageNumber'],
      farmSection: map['farmSection'],
      fatherId: map['fatherId'],
      motherId: map['motherId'],
      fatherTag: map['fatherTag'],
      motherTag: map['motherTag'],
      purchaseDate: (map['purchaseDate'] as Timestamp?)?.toDate(),
      purchaseCost: (map['purchaseCost'] as num?)?.toDouble(),
      source: map['source'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmId': farmId,
      'earTag': earTag,
      'name': name,
      'gender': gender.value,
      'breed': breed,
      'color': color,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'weight': weight,
      'status': status.value,
      'photoUrl': photoUrl,
      'cageNumber': cageNumber,
      'farmSection': farmSection,
      'fatherId': fatherId,
      'motherId': motherId,
      'fatherTag': fatherTag,
      'motherTag': motherTag,
      'purchaseDate': purchaseDate == null
          ? null
          : Timestamp.fromDate(purchaseDate!),
      'purchaseCost': purchaseCost,
      'source': source,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  RabbitModel copyWith({
    String? earTag,
    String? name,
    RabbitGender? gender,
    String? breed,
    String? color,
    DateTime? dateOfBirth,
    double? weight,
    RabbitStatus? status,
    String? photoUrl,
    String? cageNumber,
    String? farmSection,
    String? fatherId,
    String? motherId,
    String? fatherTag,
    String? motherTag,
    DateTime? purchaseDate,
    double? purchaseCost,
    String? source,
    String? notes,
    DateTime? updatedAt,
  }) {
    return RabbitModel(
      id: id,
      farmId: farmId,
      earTag: earTag ?? this.earTag,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      breed: breed ?? this.breed,
      color: color ?? this.color,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weight: weight ?? this.weight,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
      cageNumber: cageNumber ?? this.cageNumber,
      farmSection: farmSection ?? this.farmSection,
      fatherId: fatherId ?? this.fatherId,
      motherId: motherId ?? this.motherId,
      fatherTag: fatherTag ?? this.fatherTag,
      motherTag: motherTag ?? this.motherTag,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
