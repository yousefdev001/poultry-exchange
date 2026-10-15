import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/poultry_market_product.dart';

class PoultryMarketProductModel extends PoultryMarketProduct {
  const PoultryMarketProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.isActive,
    required super.updatedAt,
    super.order,
  });

  factory PoultryMarketProductModel.fromMap(Map<String, dynamic> data, String id) {
    return PoultryMarketProductModel(
      id: id,
      name: data['name'] as String? ?? '',
      price: (data['price'] as num? ?? 0.0).toDouble().ceilToDouble(),
      isActive: data['isActive'] as bool? ?? true,
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : (data['updatedAt'] is DateTime
              ? data['updatedAt'] as DateTime
              : DateTime.now()),
      order: data['order'] as int? ?? 0,
    );
  }

  factory PoultryMarketProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PoultryMarketProductModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap(String updatedBy) {
    return {
      'name': name,
      'price': price.ceilToDouble(),
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
      'order': order,
    };
  }
}
