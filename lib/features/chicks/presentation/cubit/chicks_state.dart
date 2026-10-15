import 'package:equatable/equatable.dart';
import '../../domain/entities/chick_product.dart';

abstract class ChicksState extends Equatable {
  const ChicksState();
  @override
  List<Object?> get props => [];
}

class ChicksInitial extends ChicksState {
  const ChicksInitial();
}

class ChicksLoading extends ChicksState {
  const ChicksLoading();
}

class ChicksLoaded extends ChicksState {
  final List<ChickProduct> chicks;
  final DateTime lastUpdated;

  const ChicksLoaded({required this.chicks, required this.lastUpdated});

  @override
  List<Object?> get props => [chicks, lastUpdated];
}

class ChicksError extends ChicksState {
  final String message;
  const ChicksError(this.message);

  @override
  List<Object?> get props => [message];
}
