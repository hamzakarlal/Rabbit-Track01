import 'package:cloud_firestore/cloud_firestore.dart';

enum InventoryCategory {
  feed,
  medicine,
  equipment,
  cages,
  feeders,
  waterBottles,
  nestBoxes,
  cleaningSupplies,
  vaccines,
  vitamins,
  other,
}

extension InventoryCategoryExtension on InventoryCategory {
  String get displayName {
    switch (this) {
      case InventoryCategory.feed:
        return 'Feed';
      case InventoryCategory.medicine:
        return 'Medicine';
      case InventoryCategory.equipment:
        return 'Equipment';
      case InventoryCategory.cages:
        return 'Cages';
      case InventoryCategory.feeders:
        return 'Feeders';
      case InventoryCategory.waterBottles:
        return 'Water Bottles';
      case InventoryCategory.nestBoxes:
        return 'Nest Boxes';
      case InventoryCategory.cleaningSupplies:
        return 'Cleaning Supplies';
      case InventoryCategory.vaccines:
        return 'Vaccines';
      case InventoryCategory.vitamins:
        return 'Vitamins';
      case InventoryCategory.other:
        return 'Other';
    }
  }

  String get value => name;
}

enum StockStatus { inStock, lowStock, outOfStock }

class InventoryItemModel {
  final String id;
  final String farmId;
  final String name;
  final InventoryCategory category;
  final double quantity;
  final String unit;
  final double purchasePrice;
  final double? currentValue;
  final String? supplier;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  final double minimumStockLevel;
  final String? location;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryItemModel({
    required this.id,
    required this.farmId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.purchasePrice,
    this.currentValue,
    this.supplier,
    this.purchaseDate,
    this.expiryDate,
    required this.minimumStockLevel,
    this.location,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  StockStatus get stockStatus {
    if (quantity <= 0) return StockStatus.outOfStock;
    if (quantity <= minimumStockLevel) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  bool get isExpired =>
      expiryDate != null && DateTime.now().isAfter(expiryDate!);

  bool get isExpiringSoon =>
      expiryDate != null &&
      !isExpired &&
      expiryDate!.difference(DateTime.now()).inDays <= 30;

  double get totalValue => quantity * purchasePrice;

  factory InventoryItemModel.fromMap(Map<String, dynamic> map, String id) {
    return InventoryItemModel(
      id: id,
      farmId: map['farmId'] ?? '',
      name: map['name'] ?? '',
      category: InventoryCategory.values.firstWhere(
        (c) => c.value == map['category'],
        orElse: () => InventoryCategory.other,
      ),
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0,
      unit: map['unit'] ?? 'kg',
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0,
      currentValue: (map['currentValue'] as num?)?.toDouble(),
      supplier: map['supplier'],
      purchaseDate: (map['purchaseDate'] as Timestamp?)?.toDate(),
      expiryDate: (map['expiryDate'] as Timestamp?)?.toDate(),
      minimumStockLevel: (map['minimumStockLevel'] as num?)?.toDouble() ?? 0,
      location: map['location'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmId': farmId,
      'name': name,
      'category': category.value,
      'quantity': quantity,
      'unit': unit,
      'purchasePrice': purchasePrice,
      'currentValue': currentValue,
      'supplier': supplier,
      'purchaseDate': purchaseDate == null
          ? null
          : Timestamp.fromDate(purchaseDate!),
      'expiryDate': expiryDate == null ? null : Timestamp.fromDate(expiryDate!),
      'minimumStockLevel': minimumStockLevel,
      'location': location,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  InventoryItemModel copyWith({
    String? name,
    InventoryCategory? category,
    double? quantity,
    String? unit,
    double? purchasePrice,
    double? currentValue,
    String? supplier,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    double? minimumStockLevel,
    String? location,
    String? notes,
    DateTime? updatedAt,
  }) {
    return InventoryItemModel(
      id: id,
      farmId: farmId,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentValue: currentValue ?? this.currentValue,
      supplier: supplier ?? this.supplier,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      minimumStockLevel: minimumStockLevel ?? this.minimumStockLevel,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
