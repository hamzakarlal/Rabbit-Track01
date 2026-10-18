import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? photoUrl;
  final String farmId;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.photoUrl,
    required this.farmId,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: map['photoUrl'],
      farmId: map['farmId'] ?? '',
      emailVerified: map['emailVerified'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'farmId': farmId,
      'emailVerified': emailVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? farmId,
    bool? emailVerified,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      farmId: farmId ?? this.farmId,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class FarmModel {
  final String id;
  final String ownerId;
  final String farmName;
  final String location;
  final String? description;
  final String? logoUrl;
  final String? contactNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FarmModel({
    required this.id,
    required this.ownerId,
    required this.farmName,
    required this.location,
    this.description,
    this.logoUrl,
    this.contactNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FarmModel.fromMap(Map<String, dynamic> map, String id) {
    return FarmModel(
      id: id,
      ownerId: map['ownerId'] ?? '',
      farmName: map['farmName'] ?? '',
      location: map['location'] ?? '',
      description: map['description'],
      logoUrl: map['logoUrl'],
      contactNumber: map['contactNumber'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'farmName': farmName,
      'location': location,
      'description': description,
      'logoUrl': logoUrl,
      'contactNumber': contactNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  FarmModel copyWith({
    String? id,
    String? farmName,
    String? location,
    String? description,
    String? logoUrl,
    String? contactNumber,
    DateTime? updatedAt,
  }) {
    return FarmModel(
      id: id ?? this.id,
      ownerId: ownerId,
      farmName: farmName ?? this.farmName,
      location: location ?? this.location,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      contactNumber: contactNumber ?? this.contactNumber,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
