// ============================================================
// exceptions.dart — تعريفات Exceptions لـ Data Layer
// ============================================================

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'لا يوجد اتصال بالإنترنت']);
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException([this.message = 'خطأ في الخادم', this.statusCode]);
}

class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException([this.message = 'خطأ في المصادقة', this.code]);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'غير مصرح بهذا الإجراء']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'البيانات غير موجودة']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'خطأ في التخزين المحلي']);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}
