import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/egg_product.dart';

class EggProductModel extends EggProduct {
  const EggProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.isActive,
    required super.updatedAt,
    super.order,
  });

  factory EggProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return EggProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      price: (data['price'] as num? ?? 0.0).toDouble().ceilToDouble(),
      isActive: data['isActive'] as bool? ?? true,
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      order: data['order'] as int? ?? 0,
    );
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
