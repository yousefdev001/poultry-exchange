import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AdminUser>> loginAdmin({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginAdmin(email: email, password: password);
      return Right(user);
    } on UnauthorizedException catch (e) {
      return Left(NotAdminFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<AdminUser?> getCurrentUser() => remoteDataSource.getCurrentUser();

  @override
  Stream<AdminUser?> get authStateChanges => remoteDataSource.authStateChanges;
}
