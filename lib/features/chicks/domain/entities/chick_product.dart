import 'package:equatable/equatable.dart';

class ChickProduct extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool isActive;
  final DateTime updatedAt;
  final int order;
  final String category; // 'fattening', 'sasso_baladi', 'duck_turkey'

  const ChickProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.isActive,
    required this.updatedAt,
    this.order = 0,
    this.category = 'fattening',
  });

  bool get isFattening => category == 'fattening';
  bool get isSassoBaladi => category == 'sasso_baladi';
  bool get isDuckTurkey => category == 'duck_turkey';

  String get categoryName {
    switch (category) {
      case 'sasso_baladi':
        return 'كتكوت ساسو وبلدي';
      case 'duck_turkey':
        return 'كتكوت بط ورومي';
      case 'fattening':
      default:
        return 'كتكوت تسمين';
    }
  }

  @override
  List<Object?> get props => [id, name, price, isActive, updatedAt, order, category];
}
