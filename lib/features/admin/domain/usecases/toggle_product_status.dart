import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class ToggleProductStatusParams {
  final String productId;
  final bool isActive;
  final String updatedBy;
  final String productName;
  const ToggleProductStatusParams({required this.productId, required this.isActive, required this.updatedBy, required this.productName});
}

class ToggleProductStatus {
  final AdminRepository repository;
  const ToggleProductStatus(this.repository);
  Future<Either<Failure, void>> call(ToggleProductStatusParams params) {
    return repository.toggleProductStatus(productId: params.productId, isActive: params.isActive, updatedBy: params.updatedBy, productName: params.productName);
  }
}
