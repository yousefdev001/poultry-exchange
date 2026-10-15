import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/admin_user.dart';

abstract class AuthRemoteDataSource {
  Future<AdminUser> loginAdmin({required String email, required String password});
  Future<void> logout();
  Future<AdminUser?> getCurrentUser();
  Stream<AdminUser?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({required this.auth, required this.firestore});

  @override
  Future<AdminUser> loginAdmin({required String email, required String password}) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) throw const AuthException('فشل تسجيل الدخول');

      final idTokenResult = await user.getIdTokenResult(true);
      final claimRole = idTokenResult.claims?[FirebaseConstants.roleClaimKey] as String?;

      if (claimRole == FirebaseConstants.adminRole) {
        return AdminUser(
          uid: user.uid,
          email: user.email ?? email,
          role: claimRole!,
          isActive: true,
        );
      }

      // Fallback: Firestore users collection
      final userDoc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await auth.signOut();
        throw const UnauthorizedException('ليس لديك صلاحية الوصول للوحة الإدارة');
      }

      final userData = userDoc.data()!;
      final firestoreRole = userData[FirebaseConstants.roleField] as String? ?? '';
      final isActive = userData['isActive'] as bool? ?? true;

      if (firestoreRole != FirebaseConstants.adminRole || !isActive) {
        await auth.signOut();
        throw const UnauthorizedException('ليس لديك صلاحية الوصول للوحة الإدارة');
      }

      return AdminUser(
        uid: user.uid,
        email: user.email ?? email,
        role: firestoreRole,
        isActive: isActive,
      );
    } on UnauthorizedException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
        case 'invalid-email':
          throw const AuthException('بيانات تسجيل الدخول غير صحيحة');
        case 'user-disabled':
          throw const AuthException('هذا الحساب معطل');
        case 'too-many-requests':
          throw const AuthException('تم تجاوز عدد المحاولات. يرجى الانتظار');
        default:
          throw AuthException(e.message ?? 'خطأ في تسجيل الدخول', e.code);
      }
    } catch (e) {
      if (e is UnauthorizedException || e is AuthException) rethrow;
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> logout() async => auth.signOut();

  @override
  Future<AdminUser?> getCurrentUser() async {
    final user = auth.currentUser;
    if (user == null) return null;

    try {
      final idTokenResult = await user.getIdTokenResult();
      final claimRole = idTokenResult.claims?[FirebaseConstants.roleClaimKey] as String?;

      if (claimRole == FirebaseConstants.adminRole) {
        return AdminUser(
          uid: user.uid,
          email: user.email ?? '',
          role: claimRole!,
          isActive: true,
        );
      }

      final userDoc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .get();
      if (!userDoc.exists) return null;

      final userData = userDoc.data()!;
      final role = userData[FirebaseConstants.roleField] as String? ?? '';
      if (role != FirebaseConstants.adminRole) return null;

      return AdminUser(
        uid: user.uid,
        email: user.email ?? '',
        role: role,
        isActive: userData['isActive'] as bool? ?? true,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<AdminUser?> get authStateChanges {
    return auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return getCurrentUser();
    });
  }
}
