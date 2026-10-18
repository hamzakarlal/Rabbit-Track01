import 'package:cloud_firestore/cloud_firestore.dart';

enum FeedType { hay, pellets, greens, vegetables, grains, supplements, other }

extension FeedTypeExtension on FeedType {
  String get displayName {
    switch (this) {
      case FeedType.hay:
        return 'Hay';
      case FeedType.pellets:
        return 'Pellets';
      case FeedType.greens:
        return 'Greens';
      case FeedType.vegetables:
        return 'Vegetables';
      case FeedType.grains:
        return 'Grains';
      case FeedType.supplements:
        return 'Supplements';
      case FeedType.other:
        return 'Other';
    }
  }

  String get value => name;
}

class FeedingModel {
  final String id;
  final String farmId;
  final String? rabbitId;
  final String? rabbitTag;
  final FeedType feedType;
  final String? feedName;
  final double quantity;
  final String unit;
  final double costPerUnit;
  final double totalCost;
  final DateTime feedingDate;
  final int? numberOfRabbits;
  final String? group;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FeedingModel({
    required this.id,
    required this.farmId,
    this.rabbitId,
    this.rabbitTag,
    required this.feedType,
    this.feedName,
    required this.quantity,
    required this.unit,
    required this.costPerUnit,
    required this.totalCost,
    required this.feedingDate,
    this.numberOfRabbits,
    this.group,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  static double calculateTotalCost(double quantity, double costPerUnit) =>
      quantity * costPerUnit;

  factory FeedingModel.fromMap(Map<String, dynamic> map, String id) {
    return FeedingModel(
      id: id,
      farmId: map['farmId'] ?? '',
      rabbitId: map['rabbitId'],
      rabbitTag: map['rabbitTag'],
      feedType: FeedType.values.firstWhere(
        (t) => t.value == map['feedType'],
        orElse: () => FeedType.pellets,
      ),
      feedName: map['feedName'],
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0,
      unit: map['unit'] ?? 'kg',
      costPerUnit: (map['costPerUnit'] as num?)?.toDouble() ?? 0,
      totalCost: (map['totalCost'] as num?)?.toDouble() ?? 0,
      feedingDate:
          (map['feedingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      numberOfRabbits: map['numberOfRabbits'],
      group: map['group'],
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
      'feedType': feedType.value,
      'feedName': feedName,
      'quantity': quantity,
      'unit': unit,
      'costPerUnit': costPerUnit,
      'totalCost': totalCost,
      'feedingDate': Timestamp.fromDate(feedingDate),
      'numberOfRabbits': numberOfRabbits,
      'group': group,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  FeedingModel copyWith({
    FeedType? feedType,
    String? feedName,
    double? quantity,
    String? unit,
    double? costPerUnit,
    double? totalCost,
    DateTime? feedingDate,
    int? numberOfRabbits,
    String? group,
    String? notes,
    DateTime? updatedAt,
  }) {
    return FeedingModel(
      id: id,
      farmId: farmId,
      rabbitId: rabbitId,
      rabbitTag: rabbitTag,
      feedType: feedType ?? this.feedType,
      feedName: feedName ?? this.feedName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      totalCost: totalCost ?? this.totalCost,
      feedingDate: feedingDate ?? this.feedingDate,
      numberOfRabbits: numberOfRabbits ?? this.numberOfRabbits,
      group: group ?? this.group,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ExpenseCategory {
  feed,
  medicine,
  vaccination,
  equipment,
  cages,
  electricity,
  water,
  transportation,
  labor,
  maintenance,
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.feed:
        return 'Feed';
      case ExpenseCategory.medicine:
        return 'Medicine';
      case ExpenseCategory.vaccination:
        return 'Vaccination';
      case ExpenseCategory.equipment:
        return 'Equipment';
      case ExpenseCategory.cages:
        return 'Cages';
      case ExpenseCategory.electricity:
        return 'Electricity';
      case ExpenseCategory.water:
        return 'Water';
      case ExpenseCategory.transportation:
        return 'Transportation';
      case ExpenseCategory.labor:
        return 'Labor';
      case ExpenseCategory.maintenance:
        return 'Maintenance';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  String get value => name;
}

class ExpenseModel {
  final String id;
  final String farmId;
  final DateTime date;
  final ExpenseCategory category;
  final String description;
  final double amount;
  final String? paymentMethod;
  final String? receiptUrl;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpenseModel({
    required this.id,
    required this.farmId,
    required this.date,
    required this.category,
    required this.description,
    required this.amount,
    this.paymentMethod,
    this.receiptUrl,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map, String id) {
    return ExpenseModel(
      id: id,
      farmId: map['farmId'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: ExpenseCategory.values.firstWhere(
        (c) => c.value == map['category'],
        orElse: () => ExpenseCategory.other,
      ),
      description: map['description'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      paymentMethod: map['paymentMethod'],
      receiptUrl: map['receiptUrl'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmId': farmId,
      'date': Timestamp.fromDate(date),
      'category': category.value,
      'description': description,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'receiptUrl': receiptUrl,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ExpenseModel copyWith({
    DateTime? date,
    ExpenseCategory? category,
    String? description,
    double? amount,
    String? paymentMethod,
    String? receiptUrl,
    String? notes,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id,
      farmId: farmId,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
