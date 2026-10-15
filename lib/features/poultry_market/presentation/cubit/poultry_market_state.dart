import 'package:equatable/equatable.dart';
import '../../domain/entities/poultry_market_product.dart';

abstract class PoultryMarketState extends Equatable {
  const PoultryMarketState();

  @override
  List<Object?> get props => [];
}

class PoultryMarketInitial extends PoultryMarketState {
  const PoultryMarketInitial();
}

class PoultryMarketLoading extends PoultryMarketState {
  const PoultryMarketLoading();
}

class PoultryMarketLoaded extends PoultryMarketState {
  final List<PoultryMarketProduct> products;
  final DateTime lastUpdated;

  const PoultryMarketLoaded({
    required this.products,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [products, lastUpdated];
}

class PoultryMarketError extends PoultryMarketState {
  final String message;

  const PoultryMarketError(this.message);

  @override
  List<Object?> get props => [message];
}
