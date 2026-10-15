// ============================================================
// admin_remote_data_source.dart — Admin Firestore Operations
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../admin/domain/entities/audit_log.dart';
import '../../../prices/data/models/product_model.dart';

abstract class AdminRemoteDataSource {
  Future<void> updateLivePrice({required double newPrice, required String updatedBy, required double oldPrice});
  Future<void> createProduct({required String name, required double multiplier, required double increase, required String createdBy, required int order, String category = 'frozen'});
  Future<void> updateProduct({required String productId, required String name, required double multiplier, required double increase, required String updatedBy, required Map<String, dynamic> oldValues, String category = 'frozen'});
  Future<void> toggleProductStatus({required String productId, required bool isActive, required String updatedBy, required String productName});
  Future<List<AuditLog>> getAuditLogs({int limit = 50});
  Future<List<ProductModel>> getAllProducts();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final FirebaseFirestore firestore;

  AdminRemoteDataSourceImpl({required this.firestore});

  // ---- Helper: Write Audit Log ----
  Future<void> _writeAuditLog({
    required String action,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> oldValue,
    required Map<String, dynamic> newValue,
    required String performedBy,
  }) async {
    await firestore.collection(FirebaseConstants.auditLogsCollection).add({
      FirebaseConstants.actionField: action,
      FirebaseConstants.entityTypeField: entityType,
      FirebaseConstants.entityIdField: entityId,
      FirebaseConstants.oldValueField: oldValue,
      FirebaseConstants.newValueField: newValue,
      FirebaseConstants.performedByField: performedBy,
      FirebaseConstants.performedAtField: FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateLivePrice({
    required double newPrice,
    required String updatedBy,
    required double oldPrice,
  }) async {
    try {
      final batch = firestore.batch();
      final settingsRef = firestore
          .collection(FirebaseConstants.settingsCollection)
          .doc(FirebaseConstants.livePriceDoc);

      batch.set(settingsRef, {
        FirebaseConstants.livePriceField: newPrice,
        FirebaseConstants.updatedAtField: FieldValue.serverTimestamp(),
        FirebaseConstants.updatedByField: updatedBy,
      }, SetOptions(merge: true));

      await batch.commit();

      await _writeAuditLog(
        action: 'UPDATE_LIVE_PRICE',
        entityType: 'settings',
        entityId: FirebaseConstants.livePriceDoc,
        oldValue: {'livePrice': oldPrice},
        newValue: {'livePrice': newPrice},
        performedBy: updatedBy,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'خطأ في تحديث السعر');
    }
  }

  @override
  Future<void> createProduct({
    required String name,
    required double multiplier,
    required double increase,
    required String createdBy,
    required int order,
    String category = 'frozen',
  }) async {
    try {
      final docRef = await firestore
          .collection(FirebaseConstants.productsCollection)
          .add({
        FirebaseConstants.nameField: name,
        FirebaseConstants.multiplierField: multiplier,
        FirebaseConstants.increaseField: increase,
        FirebaseConstants.isActiveField: true,
        FirebaseConstants.categoryField: category,
        FirebaseConstants.createdAtField: FieldValue.serverTimestamp(),
        FirebaseConstants.updatedAtField: FieldValue.serverTimestamp(),
        FirebaseConstants.createdByField: createdBy,
        FirebaseConstants.updatedByField: createdBy,
        FirebaseConstants.orderField: order,
      });

      await _writeAuditLog(
        action: 'ADD_PRODUCT',
        entityType: 'products',
        entityId: docRef.id,
        oldValue: {},
        newValue: {'name': name, 'multiplier': multiplier, 'increase': increase, 'category': category},
        performedBy: createdBy,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'خطأ في إضافة الصنف');
    }
  }

  @override
  Future<void> updateProduct({
    required String productId,
    required String name,
    required double multiplier,
    required double increase,
    required String updatedBy,
    required Map<String, dynamic> oldValues,
    String category = 'frozen',
  }) async {
    try {
      await firestore
          .collection(FirebaseConstants.productsCollection)
          .doc(productId)
          .update({
        FirebaseConstants.nameField: name,
        FirebaseConstants.multiplierField: multiplier,
        FirebaseConstants.increaseField: increase,
        FirebaseConstants.categoryField: category,
        FirebaseConstants.updatedAtField: FieldValue.serverTimestamp(),
        FirebaseConstants.updatedByField: updatedBy,
      });

      await _writeAuditLog(
        action: 'UPDATE_PRODUCT',
        entityType: 'products',
        entityId: productId,
        oldValue: oldValues,
        newValue: {'name': name, 'multiplier': multiplier, 'increase': increase, 'category': category},
        performedBy: updatedBy,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'خطأ في تعديل الصنف');
    }
  }

  @override
  Future<void> toggleProductStatus({
    required String productId,
    required bool isActive,
    required String updatedBy,
    required String productName,
  }) async {
    try {
      await firestore
          .collection(FirebaseConstants.productsCollection)
          .doc(productId)
          .update({
        FirebaseConstants.isActiveField: isActive,
        FirebaseConstants.updatedAtField: FieldValue.serverTimestamp(),
        FirebaseConstants.updatedByField: updatedBy,
      });

      await _writeAuditLog(
        action: isActive ? 'ENABLE_PRODUCT' : 'DISABLE_PRODUCT',
        entityType: 'products',
        entityId: productId,
        oldValue: {'isActive': !isActive, 'name': productName},
        newValue: {'isActive': isActive, 'name': productName},
        performedBy: updatedBy,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'خطأ في تغيير حالة الصنف');
    }
  }

  @override
  Future<List<AuditLog>> getAuditLogs({int limit = 50}) async {
    try {
      final query = await firestore
          .collection(FirebaseConstants.auditLogsCollection)
          .orderBy(FirebaseConstants.performedAtField, descending: true)
          .limit(limit)
          .get()
          .timeout(const Duration(seconds: 8));

      return query.docs.map((doc) {
        final data = doc.data();
        return AuditLog(
          id: doc.id,
          action: _parseAction(data[FirebaseConstants.actionField] as String? ?? ''),
          entityType: data[FirebaseConstants.entityTypeField] as String? ?? '',
          entityId: data[FirebaseConstants.entityIdField] as String? ?? '',
          oldValue: Map<String, dynamic>.from(data[FirebaseConstants.oldValueField] as Map? ?? {}),
          newValue: Map<String, dynamic>.from(data[FirebaseConstants.newValueField] as Map? ?? {}),
          performedBy: data[FirebaseConstants.performedByField] as String? ?? '',
          performedAt: data[FirebaseConstants.performedAtField] is Timestamp
              ? (data[FirebaseConstants.performedAtField] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'خطأ في تحميل سجل التعديلات');
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final query = await firestore
          .collection(FirebaseConstants.productsCollection)
          .get()
          .timeout(const Duration(seconds: 10));
      final products = query.docs.map(ProductModel.fromFirestore).toList();
      products.sort((a, b) => a.order.compareTo(b.order));
      return products;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'خطأ في تحميل الأصناف');
    }
  }

  AuditAction _parseAction(String action) {
    switch (action) {
      case 'UPDATE_LIVE_PRICE':
        return AuditAction.updateLivePrice;
      case 'ADD_PRODUCT':
        return AuditAction.addProduct;
      case 'UPDATE_PRODUCT':
        return AuditAction.updateProduct;
      case 'DISABLE_PRODUCT':
        return AuditAction.disableProduct;
      case 'ENABLE_PRODUCT':
        return AuditAction.enableProduct;
      default:
        return AuditAction.updateProduct;
    }
  }
}
