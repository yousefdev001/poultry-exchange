import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../prices/domain/entities/product.dart';
import '../entities/audit_log.dart';

abstract class AdminRepository {
  Future<Either<Failure, void>> updateLivePrice({required double newPrice, required String updatedBy});
  Future<Either<Failure, void>> createProduct({required String name, required double multiplier, required double increase, required String createdBy, String category = 'frozen'});
  Future<Either<Failure, void>> updateProduct({required String productId, required String name, required double multiplier, required double increase, required String updatedBy, required Product oldProduct, String category = 'frozen'});
  Future<Either<Failure, void>> toggleProductStatus({required String productId, required bool isActive, required String updatedBy, required String productName});
  Future<Either<Failure, List<AuditLog>>> getAuditLogs({int limit = 50});
  Future<Either<Failure, List<Product>>> getAllProducts();
}
