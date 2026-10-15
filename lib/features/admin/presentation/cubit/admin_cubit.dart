import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../prices/domain/entities/live_price.dart';
import '../../../prices/domain/usecases/get_live_price.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/usecases/update_live_price.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/toggle_product_status.dart';
import '../../domain/usecases/get_audit_logs.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../prices/domain/entities/product.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final GetLivePrice getLivePrice;
  final UpdateLivePrice updateLivePrice;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final ToggleProductStatus toggleProductStatus;
  final GetAuditLogs getAuditLogs;
  final AdminRepository adminRepository;

  AdminCubit({
    required this.getLivePrice,
    required this.updateLivePrice,
    required this.createProduct,
    required this.updateProduct,
    required this.toggleProductStatus,
    required this.getAuditLogs,
    required this.adminRepository,
  }) : super(const AdminInitial());

  Future<void> loadDashboard() async {
    emit(const AdminLoading());
    try {
      final livePriceResult = await getLivePrice();
      final productsResult = await adminRepository.getAllProducts();

      LivePrice? livePrice;
      livePriceResult.fold((_) {}, (p) => livePrice = p);

      List<Product> products = [];
      productsResult.fold((_) {}, (p) => products = p);

      // تحميل السجل بشكل منفصل — إذا فشل لا يوقف باقي البيانات
      List<AuditLog> logsData = [];
      try {
        final logsResult = await getAuditLogs(limit: 20);
        logsResult.fold((_) {}, (l) => logsData = l.cast<AuditLog>());
      } catch (_) {
        // السجل اختياري — نكمل حتى لو فشل
      }

      emit(AdminLoaded(
        livePrice: livePrice,
        products: products,
        auditLogs: logsData,
      ));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> changeLivePrice(
      {required double newPrice, required String updatedBy}) async {
    final currentState = state;
    emit(const AdminOperationLoading('update_price'));

    final result = await updateLivePrice(
      UpdateLivePriceParams(newPrice: newPrice, updatedBy: updatedBy),
    );

    result.fold(
      (failure) {
        if (currentState is AdminLoaded) emit(currentState);
        emit(AdminError(failure.message));
      },
      (_) async {
        emit(const AdminOperationSuccess('تم تحديث سعر اللحم الحي بنجاح'));
        await loadDashboard();
      },
    );
  }

  Future<void> addProduct({
    required String name,
    required double multiplier,
    required double increase,
    required String createdBy,
    String category = 'frozen',
  }) async {
    final currentState = state;
    emit(const AdminOperationLoading('create_product'));

    final result = await createProduct(
      CreateProductParams(
        name: name,
        multiplier: multiplier,
        increase: increase,
        createdBy: createdBy,
        category: category,
      ),
    );

    result.fold(
      (failure) {
        if (currentState is AdminLoaded) emit(currentState);
        emit(AdminError(failure.message));
      },
      (_) async {
        emit(const AdminOperationSuccess('تم إضافة الصنف بنجاح'));
        await loadDashboard();
      },
    );
  }

  Future<void> editProduct({
    required String productId,
    required String name,
    required double multiplier,
    required double increase,
    required String updatedBy,
    required Product oldProduct,
    String category = 'frozen',
  }) async {
    final currentState = state;
    emit(const AdminOperationLoading('update_product'));

    final result = await updateProduct(UpdateProductParams(
      productId: productId,
      name: name,
      multiplier: multiplier,
      increase: increase,
      updatedBy: updatedBy,
      oldProduct: oldProduct,
      category: category,
    ));

    result.fold(
      (failure) {
        if (currentState is AdminLoaded) emit(currentState);
        emit(AdminError(failure.message));
      },
      (_) async {
        emit(const AdminOperationSuccess('تم تعديل الصنف بنجاح'));
        await loadDashboard();
      },
    );
  }

  Future<void> toggleStatus({
    required String productId,
    required bool isActive,
    required String updatedBy,
    required String productName,
  }) async {
    final currentState = state;
    emit(const AdminOperationLoading('toggle_status'));

    final result = await toggleProductStatus(ToggleProductStatusParams(
      productId: productId,
      isActive: isActive,
      updatedBy: updatedBy,
      productName: productName,
    ));

    result.fold(
      (failure) {
        if (currentState is AdminLoaded) emit(currentState);
        emit(AdminError(failure.message));
      },
      (_) async {
        final successMsg =
            isActive ? 'تم تفعيل الصنف بنجاح' : 'تم تعطيل الصنف بنجاح';
        emit(AdminOperationSuccess(successMsg));
        await loadDashboard();
      },
    );
  }

  Future<void> loadAuditLogs() async {
    final currentState = state;
    final result = await getAuditLogs(limit: 50);
    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (logs) {
        if (currentState is AdminLoaded) {
          emit(currentState.copyWith(auditLogs: logs));
        }
      },
    );
  }
}
