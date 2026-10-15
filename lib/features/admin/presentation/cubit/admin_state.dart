import 'package:equatable/equatable.dart';
import '../../../prices/domain/entities/product.dart';
import '../../../prices/domain/entities/live_price.dart';
import '../../domain/entities/audit_log.dart';

abstract class AdminState extends Equatable {
  const AdminState();
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState { const AdminInitial(); }
class AdminLoading extends AdminState { const AdminLoading(); }

class AdminLoaded extends AdminState {
  final LivePrice? livePrice;
  final List<Product> products;
  final List<AuditLog> auditLogs;

  const AdminLoaded({
    this.livePrice,
    this.products = const [],
    this.auditLogs = const [],
  });

  int get activeProductsCount => products.where((p) => p.isActive).length;
  int get inactiveProductsCount => products.where((p) => !p.isActive).length;

  AdminLoaded copyWith({
    LivePrice? livePrice,
    List<Product>? products,
    List<AuditLog>? auditLogs,
  }) {
    return AdminLoaded(
      livePrice: livePrice ?? this.livePrice,
      products: products ?? this.products,
      auditLogs: auditLogs ?? this.auditLogs,
    );
  }

  @override
  List<Object?> get props => [livePrice, products, auditLogs];
}

class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);
  @override
  List<Object> get props => [message];
}

class AdminOperationLoading extends AdminState {
  final String operationKey;
  const AdminOperationLoading(this.operationKey);
  @override
  List<Object> get props => [operationKey];
}

class AdminOperationSuccess extends AdminState {
  final String message;
  const AdminOperationSuccess(this.message);
  @override
  List<Object> get props => [message];
}
