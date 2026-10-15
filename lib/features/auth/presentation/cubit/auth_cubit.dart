import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/usecases/login_admin.dart';
import '../../domain/usecases/logout_admin.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginAdmin loginAdmin;
  final LogoutAdmin logoutAdmin;
  final AuthRepository authRepository;

  AuthCubit({
    required this.loginAdmin,
    required this.logoutAdmin,
    required this.authRepository,
  }) : super(const AuthInitial());

  Future<void> checkCurrentUser() async {
    final user = await authRepository.getCurrentUser();
    if (user != null && user.isAdmin) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await loginAdmin(LoginAdminParams(email: email, password: password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> logout() async {
    await logoutAdmin();
    emit(const AuthUnauthenticated());
  }

  AdminUser? get currentUser {
    final state = this.state;
    if (state is AuthAuthenticated) return state.user;
    return null;
  }
}
