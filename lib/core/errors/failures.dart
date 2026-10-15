// ============================================================
// failures.dart — تعريفات أخطاء Domain Layer
// ============================================================

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'حدث خطأ في الاتصال بالخادم']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'بيانات تسجيل الدخول غير صحيحة']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'غير مصرح لك بهذا الإجراء']);
}

class NotAdminFailure extends Failure {
  const NotAdminFailure([super.message = 'ليس لديك صلاحية الوصول للوحة الإدارة']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'البيانات المطلوبة غير موجودة']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'تعذر تحميل البيانات المحفوظة']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'انتهت مهلة الاتصال. يرجى المحاولة مجدداً']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'حدث خطأ غير متوقع']);
}
