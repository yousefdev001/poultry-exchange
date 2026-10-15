import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chick_product.dart';

class ChickProductModel extends ChickProduct {
  const ChickProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.isActive,
    required super.updatedAt,
    super.order,
    super.category = 'fattening',
  });

  factory ChickProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Resolve category with intelligent name-based fallback for old documents
    String category = data['category'] as String? ?? '';
    if (category.isEmpty) {
      final nameLower = (data['name'] as String? ?? '').toLowerCase();
      if (nameLower.contains('بط') ||
          nameLower.contains('رومي') ||
          nameLower.contains('مولار') ||
          nameLower.contains('مسكوفي') ||
          nameLower.contains('فرنساوي')) {
        category = 'duck_turkey';
      } else if (nameLower.contains('ساسو') ||
          nameLower.contains('بلدي') ||
          nameLower.contains('فيومي') ||
          nameLower.contains('هجين') ||
          nameLower.contains('روزي')) {
        category = 'sasso_baladi';
      } else {
        category = 'fattening';
      }
    }

    return ChickProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      price: (data['price'] as num? ?? 0.0).toDouble().ceilToDouble(),
      isActive: data['isActive'] as bool? ?? true,
      category: category,
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
      'category': category,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
      'order': order,
    };
  }
}
