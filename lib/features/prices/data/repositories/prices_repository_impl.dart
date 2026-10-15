import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/live_price.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/prices_repository.dart';
import '../datasources/prices_local_data_source.dart';
import '../datasources/prices_remote_data_source.dart';

class PricesRepositoryImpl implements PricesRepository {
  final PricesRemoteDataSource remoteDataSource;
  final PricesLocalDataSource localDataSource;
  final ConnectivityService connectivity;

  const PricesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, LivePrice>> getLivePrice() async {
    final isConnected = await connectivity.isConnected();
    if (isConnected) {
      try {
        final remote = await remoteDataSource.getLivePrice();
        await localDataSource.cacheLivePrice(remote);
        return Right(remote);
      } on NotFoundException {
        return const Left(NotFoundFailure(
            'سعر اللحم الحي غير مُعيَّن بعد. يرجى التواصل مع المسؤول'));
      } on ServerException {
        final cached = localDataSource.getCachedLivePrice();
        if (cached != null) return Right(cached);
        return const Left(
            ServerFailure('تعذّر الاتصال بالخادم. يرجى المحاولة لاحقاً'));
      } catch (_) {
        final cached = localDataSource.getCachedLivePrice();
        if (cached != null) return Right(cached);
        return const Left(
            ServerFailure('تعذّر تحميل البيانات. يرجى المحاولة لاحقاً'));
      }
    } else {
      final cached = localDataSource.getCachedLivePrice();
      if (cached != null) return Right(cached);
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getActiveProducts() async {
    final isConnected = await connectivity.isConnected();
    if (isConnected) {
      try {
        final remote = await remoteDataSource.getActiveProducts();
        await localDataSource.cacheProducts(remote);
        return Right(remote);
      } on ServerException {
        final cached = localDataSource.getCachedProducts();
        if (cached != null) return Right(cached);
        return const Left(
            ServerFailure('تعذّر تحميل الأصناف. يرجى المحاولة لاحقاً'));
      } catch (_) {
        final cached = localDataSource.getCachedProducts();
        if (cached != null) return Right(cached);
        return const Left(
            ServerFailure('تعذّر تحميل البيانات. يرجى المحاولة لاحقاً'));
      }
    } else {
      final cached = localDataSource.getCachedProducts();
      if (cached != null) return Right(cached);
      return const Left(NetworkFailure());
    }
  }
}
