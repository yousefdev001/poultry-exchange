import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/audit_log.dart';
import '../repositories/admin_repository.dart';

class GetAuditLogs {
  final AdminRepository repository;
  const GetAuditLogs(this.repository);
  Future<Either<Failure, List<AuditLog>>> call({int limit = 50}) {
    return repository.getAuditLogs(limit: limit);
  }
}
