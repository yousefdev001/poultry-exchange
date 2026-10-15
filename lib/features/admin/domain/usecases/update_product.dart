import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../prices/domain/entities/product.dart';
import '../repositories/admin_repository.dart';

class UpdateProductParams {
  final String productId;
  final String name;
  final double multiplier;
  final double increase;
  final String updatedBy;
  final Product oldProduct;
  final String category;
  const UpdateProductParams({
    required this.productId,
    required this.name,
    required this.multiplier,
    required this.increase,
    required this.updatedBy,
    required this.oldProduct,
    this.category = 'frozen',
  });
}

class UpdateProduct {
  final AdminRepository repository;
  const UpdateProduct(this.repository);
  Future<Either<Failure, void>> call(UpdateProductParams params) {
    return repository.updateProduct(
      productId: params.productId,
      name: params.name,
      multiplier: params.multiplier,
      increase: params.increase,
      updatedBy: params.updatedBy,
      oldProduct: params.oldProduct,
      category: params.category,
    );
  }
}
