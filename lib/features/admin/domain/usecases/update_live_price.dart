import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class UpdateLivePriceParams {
  final double newPrice;
  final String updatedBy;
  const UpdateLivePriceParams({required this.newPrice, required this.updatedBy});
}

class UpdateLivePrice {
  final AdminRepository repository;
  const UpdateLivePrice(this.repository);
  Future<Either<Failure, void>> call(UpdateLivePriceParams params) {
    return repository.updateLivePrice(newPrice: params.newPrice, updatedBy: params.updatedBy);
  }
}
