import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AdminUser>> loginAdmin({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> logout();
  Future<AdminUser?> getCurrentUser();
  Stream<AdminUser?> get authStateChanges;
}
