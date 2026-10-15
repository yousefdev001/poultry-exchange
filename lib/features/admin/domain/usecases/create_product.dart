import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class CreateProductParams {
  final String name;
  final double multiplier;
  final double increase;
  final String createdBy;
  final String category;
  const CreateProductParams({
    required this.name,
    required this.multiplier,
    required this.increase,
    required this.createdBy,
    this.category = 'frozen',
  });
}

class CreateProduct {
  final AdminRepository repository;
  const CreateProduct(this.repository);
  Future<Either<Failure, void>> call(CreateProductParams params) {
    return repository.createProduct(
      name: params.name,
      multiplier: params.multiplier,
      increase: params.increase,
      createdBy: params.createdBy,
      category: params.category,
    );
  }
}
