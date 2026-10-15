import 'package:equatable/equatable.dart';

enum AuditAction {
  updateLivePrice,
  addProduct,
  updateProduct,
  disableProduct,
  enableProduct,
}

class AuditLog extends Equatable {
  final String id;
  final AuditAction action;
  final String entityType;
  final String entityId;
  final Map<String, dynamic> oldValue;
  final Map<String, dynamic> newValue;
  final String performedBy;
  final DateTime performedAt;

  const AuditLog({
    required this.id,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.oldValue,
    required this.newValue,
    required this.performedBy,
    required this.performedAt,
  });

  String get actionDisplayName {
    switch (action) {
      case AuditAction.updateLivePrice:
        return 'تغيير سعر الحي';
      case AuditAction.addProduct:
        return 'إضافة صنف';
      case AuditAction.updateProduct:
        return 'تعديل صنف';
      case AuditAction.disableProduct:
        return 'تعطيل صنف';
      case AuditAction.enableProduct:
        return 'تفعيل صنف';
    }
  }

  @override
  List<Object> get props => [id, action, entityId, performedAt];
}
