import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentMethod { cash, bankTransfer, mobileMoney, credit, other }

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.mobileMoney:
        return 'Mobile Money';
      case PaymentMethod.credit:
        return 'Credit';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  String get value => name;
}

enum PaymentStatus { paid, pending, partial }

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.partial:
        return 'Partial';
    }
  }

  String get value => name;
}

enum SaleType { individual, bulk, meat, breeding, kits }

extension SaleTypeExtension on SaleType {
  String get displayName {
    switch (this) {
      case SaleType.individual:
        return 'Individual';
      case SaleType.bulk:
        return 'Bulk';
      case SaleType.meat:
        return 'Meat';
      case SaleType.breeding:
        return 'Breeding Stock';
      case SaleType.kits:
        return 'Kits';
    }
  }

  String get value => name;
}

class SaleModel {
  final String id;
  final String farmId;
  final String? rabbitId;
  final String? rabbitTag;
  final List<String> rabbitIds;
  final List<String> rabbitTags;
  final String customerName;
  final String? customerPhone;
  final DateTime saleDate;
  final double? weight;
  final double? pricePerKg;
  final double totalPrice;
  final SaleType saleType;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SaleModel({
    required this.id,
    required this.farmId,
    this.rabbitId,
    this.rabbitTag,
    required this.rabbitIds,
    required this.rabbitTags,
    required this.customerName,
    this.customerPhone,
    required this.saleDate,
    this.weight,
    this.pricePerKg,
    required this.totalPrice,
    required this.saleType,
    required this.paymentMethod,
    required this.paymentStatus,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  static double calculateTotalByWeight(double weight, double pricePerKg) =>
      weight * pricePerKg;

  int get rabbitCount => rabbitIds.length;

  factory SaleModel.fromMap(Map<String, dynamic> map, String id) {
    return SaleModel(
      id: id,
      farmId: map['farmId'] ?? '',
      rabbitId: map['rabbitId'],
      rabbitTag: map['rabbitTag'],
      rabbitIds: List<String>.from(map['rabbitIds'] ?? []),
      rabbitTags: List<String>.from(map['rabbitTags'] ?? []),
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'],
      saleDate: (map['saleDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      weight: (map['weight'] as num?)?.toDouble(),
      pricePerKg: (map['pricePerKg'] as num?)?.toDouble(),
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0,
      saleType: SaleType.values.firstWhere(
        (t) => t.value == map['saleType'],
        orElse: () => SaleType.individual,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (m) => m.value == map['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (s) => s.value == map['paymentStatus'],
        orElse: () => PaymentStatus.paid,
      ),
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
      'rabbitIds': rabbitIds,
      'rabbitTags': rabbitTags,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'saleDate': Timestamp.fromDate(saleDate),
      'weight': weight,
      'pricePerKg': pricePerKg,
      'totalPrice': totalPrice,
      'saleType': saleType.value,
      'paymentMethod': paymentMethod.value,
      'paymentStatus': paymentStatus.value,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  SaleModel copyWith({
    String? customerName,
    String? customerPhone,
    double? weight,
    double? pricePerKg,
    double? totalPrice,
    SaleType? saleType,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    String? notes,
    DateTime? updatedAt,
  }) {
    return SaleModel(
      id: id,
      farmId: farmId,
      rabbitId: rabbitId,
      rabbitTag: rabbitTag,
      rabbitIds: rabbitIds,
      rabbitTags: rabbitTags,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      saleDate: saleDate,
      weight: weight ?? this.weight,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      totalPrice: totalPrice ?? this.totalPrice,
      saleType: saleType ?? this.saleType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum NotificationType {
  vaccination,
  kindling,
  lowInventory,
  medicineExpiry,
  breeding,
  healthFollowup,
  sale,
  general,
}

extension NotificationTypeExtension on NotificationType {
  String get value => name;

  String get displayName {
    switch (this) {
      case NotificationType.vaccination:
        return 'Vaccination';
      case NotificationType.kindling:
        return 'Kindling';
      case NotificationType.lowInventory:
        return 'Low Inventory';
      case NotificationType.medicineExpiry:
        return 'Medicine Expiry';
      case NotificationType.breeding:
        return 'Breeding';
      case NotificationType.healthFollowup:
        return 'Health Follow-up';
      case NotificationType.sale:
        return 'Sale';
      case NotificationType.general:
        return 'General';
    }
  }
}

class NotificationModel {
  final String id;
  final String farmId;
  final String title;
  final String body;
  final NotificationType type;
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.farmId,
    required this.title,
    required this.body,
    required this.type,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      farmId: map['farmId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: NotificationType.values.firstWhere(
        (t) => t.value == map['type'],
        orElse: () => NotificationType.general,
      ),
      referenceId: map['referenceId'],
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmId': farmId,
      'title': title,
      'body': body,
      'type': type.value,
      'referenceId': referenceId,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      farmId: farmId,
      title: title,
      body: body,
      type: type,
      referenceId: referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
