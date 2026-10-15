import 'package:equatable/equatable.dart';

class PoultryMarketProduct extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool isActive;
  final DateTime updatedAt;
  final int order;

  const PoultryMarketProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.isActive,
    required this.updatedAt,
    this.order = 0,
  });

  @override
  List<Object?> get props => [id, name, price, isActive, updatedAt, order];
}
