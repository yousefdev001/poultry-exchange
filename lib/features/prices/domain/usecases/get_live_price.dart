import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/live_price.dart';
import '../repositories/prices_repository.dart';

class GetLivePrice {
  final PricesRepository repository;
  const GetLivePrice(this.repository);
  Future<Either<Failure, LivePrice>> call() => repository.getLivePrice();
}
