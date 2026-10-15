import 'package:equatable/equatable.dart';

class LivePrice extends Equatable {
  final double price;
  final DateTime updatedAt;
  final String updatedBy;

  const LivePrice({
    required this.price,
    required this.updatedAt,
    required this.updatedBy,
  });

  @override
  List<Object> get props => [price, updatedAt, updatedBy];
}
