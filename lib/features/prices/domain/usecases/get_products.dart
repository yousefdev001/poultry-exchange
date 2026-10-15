import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/prices_repository.dart';

class GetActiveProducts {
  final PricesRepository repository;
  const GetActiveProducts(this.repository);
  Future<Either<Failure, List<Product>>> call() => repository.getActiveProducts();
}
