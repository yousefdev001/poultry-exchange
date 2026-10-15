// ============================================================
// admin_repository_impl.dart
// ============================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../prices/domain/entities/product.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  const AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> updateLivePrice({
    required double newPrice,
    required String updatedBy,
  }) async {
    try {
      // Get current price for audit log
      // We pass 0 as old price if unavailable — the data source handles the audit log
      await remoteDataSource.updateLivePrice(
        newPrice: newPrice,
        updatedBy: updatedBy,
        oldPrice: 0,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createProduct({
    required String name,
    required double multiplier,
    required double increase,
    required String createdBy,
    String category = 'frozen',
  }) async {
    try {
      // Get current product count for ordering
      final productsResult = await getAllProducts();
      int order = 0;
      productsResult.fold(
        (_) => order = 0,
        (products) => order = products.length,
      );

      await remoteDataSource.createProduct(
        name: name,
        multiplier: multiplier,
        increase: increase,
        createdBy: createdBy,
        order: order,
        category: category,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct({
    required String productId,
    required String name,
    required double multiplier,
    required double increase,
    required String updatedBy,
    required Product oldProduct,
    String category = 'frozen',
  }) async {
    try {
      await remoteDataSource.updateProduct(
        productId: productId,
        name: name,
        multiplier: multiplier,
        increase: increase,
        updatedBy: updatedBy,
        oldValues: {
          'name': oldProduct.name,
          'multiplier': oldProduct.multiplier,
          'increase': oldProduct.increase,
          'category': oldProduct.category,
        },
        category: category,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleProductStatus({
    required String productId,
    required bool isActive,
    required String updatedBy,
    required String productName,
  }) async {
    try {
      await remoteDataSource.toggleProductStatus(
        productId: productId,
        isActive: isActive,
        updatedBy: updatedBy,
        productName: productName,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AuditLog>>> getAuditLogs({int limit = 50}) async {
    try {
      final logs = await remoteDataSource.getAuditLogs(limit: limit);
      return Right(logs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.getAllProducts();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
