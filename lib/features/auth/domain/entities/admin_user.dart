import 'package:equatable/equatable.dart';

class AdminUser extends Equatable {
  final String uid;
  final String email;
  final String role;
  final bool isActive;

  const AdminUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.isActive,
  });

  bool get isAdmin => role == 'admin';

  @override
  List<Object> get props => [uid, email, role, isActive];
}
