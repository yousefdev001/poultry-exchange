import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/live_price.dart';

class LivePriceModel extends LivePrice {
  const LivePriceModel({
    required super.price,
    required super.updatedAt,
    required super.updatedBy,
  });

  factory LivePriceModel.fromMap(Map<String, dynamic> map) {
    return LivePriceModel(
      price: (map['livePrice'] as num).toDouble(),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedBy: map['updatedBy'] as String? ?? '',
    );
  }

  factory LivePriceModel.fromCacheMap(Map<String, dynamic> map) {
    return LivePriceModel(
      price: (map['livePrice'] as num).toDouble(),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      updatedBy: map['updatedBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'livePrice': price,
      'updatedAt': updatedAt.toIso8601String(),
      'updatedBy': updatedBy,
    };
  }
}
