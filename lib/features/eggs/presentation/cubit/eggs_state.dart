import 'package:equatable/equatable.dart';
import '../../domain/entities/egg_product.dart';

abstract class EggsState extends Equatable {
  const EggsState();
  @override
  List<Object?> get props => [];
}

class EggsInitial extends EggsState {
  const EggsInitial();
}

class EggsLoading extends EggsState {
  const EggsLoading();
}

class EggsLoaded extends EggsState {
  final List<EggProduct> eggs;
  final DateTime lastUpdated;

  const EggsLoaded({required this.eggs, required this.lastUpdated});

  @override
  List<Object?> get props => [eggs, lastUpdated];
}

class EggsError extends EggsState {
  final String message;
  const EggsError(this.message);

  @override
  List<Object?> get props => [message];
}
