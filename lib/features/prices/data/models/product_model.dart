import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.multiplier,
    required super.increase,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.order,
    super.category = 'frozen',
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      multiplier: (data['multiplier'] as num? ?? 1.0).toDouble(),
      increase: (data['increase'] as num? ?? 0.0).toDouble(),
      isActive: data['isActive'] as bool? ?? true,
      category: data['category'] as String? ?? 'frozen',
      createdAt: data['createdAt'] is Timestamp ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: data['updatedAt'] is Timestamp ? (data['updatedAt'] as Timestamp).toDate() : DateTime.now(),
      order: data['order'] as int? ?? 0,
    );
  }

  factory ProductModel.fromCacheMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      multiplier: (map['multiplier'] as num).toDouble(),
      increase: (map['increase'] as num).toDouble(),
      isActive: map['isActive'] as bool? ?? true,
      category: map['category'] as String? ?? 'frozen',
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      order: map['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toCacheMap() {
    return {
      'id': id,
      'name': name,
      'multiplier': multiplier,
      'increase': increase,
      'isActive': isActive,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'order': order,
    };
  }
}
