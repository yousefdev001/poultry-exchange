import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/poultry_market_product_model.dart';

abstract class PoultryMarketRemoteDataSource {
  Future<List<PoultryMarketProductModel>> getActiveProducts();
  Future<List<PoultryMarketProductModel>> getAllProducts();
  Future<void> addProduct({required String name, required double price, required String updatedBy});
  Future<void> updateProduct({required String id, required String name, required double price, required String updatedBy});
  Future<void> toggleProductStatus({required String id, required bool isActive, required String updatedBy});
  Future<void> deleteProduct(String id);
}

class PoultryMarketRemoteDataSourceImpl implements PoultryMarketRemoteDataSource {
  final FirebaseFirestore firestore;
  static const String collection = 'poultry_market_prices';

  PoultryMarketRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PoultryMarketProductModel>> getActiveProducts() async {
    final snap = await firestore
        .collection(collection)
        .get()
        .timeout(const Duration(seconds: 10));
    final items = snap.docs
        .map(PoultryMarketProductModel.fromFirestore)
        .where((p) => p.isActive)
        .toList();
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  @override
  Future<List<PoultryMarketProductModel>> getAllProducts() async {
    final snap = await firestore
        .collection(collection)
        .get()
        .timeout(const Duration(seconds: 10));
    final items = snap.docs.map(PoultryMarketProductModel.fromFirestore).toList();
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  @override
  Future<void> addProduct({required String name, required double price, required String updatedBy}) async {
    int count = 0;
    try {
      count = (await firestore.collection(collection).count().get().timeout(const Duration(seconds: 4))).count ?? 0;
    } catch (_) {
      count = 0;
    }
    await firestore.collection(collection).add({
      'name': name,
      'price': price.ceilToDouble(),
      'isActive': true,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
      'order': count,
    });
  }

  @override
  Future<void> updateProduct({required String id, required String name, required double price, required String updatedBy}) async {
    await firestore.collection(collection).doc(id).update({
      'name': name,
      'price': price.ceilToDouble(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }

  @override
  Future<void> toggleProductStatus({required String id, required bool isActive, required String updatedBy}) async {
    await firestore.collection(collection).doc(id).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }

  @override
  Future<void> deleteProduct(String id) async {
    await firestore.collection(collection).doc(id).delete();
  }
}
