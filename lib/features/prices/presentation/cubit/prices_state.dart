import 'package:equatable/equatable.dart';
import '../../domain/entities/live_price.dart';
import '../../domain/entities/product.dart';

abstract class PricesState extends Equatable {
  const PricesState();
  @override
  List<Object?> get props => [];
}

class PricesInitial extends PricesState {
  const PricesInitial();
}

class PricesLoading extends PricesState {
  const PricesLoading();
}

class PricesLoaded extends PricesState {
  final LivePrice livePrice;
  final List<Product> products;
  final bool isOffline;
  final DateTime? lastUpdated;

  const PricesLoaded({
    required this.livePrice,
    required this.products,
    this.isOffline = false,
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [livePrice, products, isOffline, lastUpdated];
}

class PricesError extends PricesState {
  final String message;
  final bool isNetworkError;

  const PricesError({required this.message, this.isNetworkError = false});

  @override
  List<Object> get props => [message, isNetworkError];
}
