import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/live_price.dart';
import '../entities/product.dart';

abstract class PricesRepository {
  Future<Either<Failure, LivePrice>> getLivePrice();
  Future<Either<Failure, List<Product>>> getActiveProducts();
}
