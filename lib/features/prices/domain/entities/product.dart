import 'package:equatable/equatable.dart';
import '../../../../core/utils/price_calculator.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double multiplier;
  final double increase;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int order;
  final String category; // 'frozen' or 'fresh'

  const Product({
    required this.id,
    required this.name,
    required this.multiplier,
    required this.increase,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.order = 0,
    this.category = 'frozen',
  });

  bool get isFresh => category == 'fresh';
  bool get isFrozen => category != 'fresh';

  double calculatePrice(double livePrice) {
    return PriceCalculator.calculateFinalPrice(
      livePrice: livePrice,
      multiplier: multiplier,
      increase: increase,
    );
  }

  Product copyWith({
    String? id, String? name, double? multiplier, double? increase,
    bool? isActive, DateTime? createdAt, DateTime? updatedAt, int? order,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      multiplier: multiplier ?? this.multiplier,
      increase: increase ?? this.increase,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      order: order ?? this.order,
      category: category ?? this.category,
    );
  }

  @override
  List<Object> get props => [id, name, multiplier, increase, isActive, order, category];
}
