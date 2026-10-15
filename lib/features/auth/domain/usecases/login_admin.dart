import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_user.dart';
import '../repositories/auth_repository.dart';

class LoginAdminParams {
  final String email;
  final String password;
  const LoginAdminParams({required this.email, required this.password});
}

class LoginAdmin {
  final AuthRepository repository;
  const LoginAdmin(this.repository);

  Future<Either<Failure, AdminUser>> call(LoginAdminParams params) {
    return repository.loginAdmin(
      email: params.email,
      password: params.password,
    );
  }
}
