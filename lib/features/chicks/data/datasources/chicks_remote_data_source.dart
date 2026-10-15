import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chick_product_model.dart';

abstract class ChicksRemoteDataSource {
  Future<List<ChickProductModel>> getActiveChicks();
  Future<List<ChickProductModel>> getAllChicks();
  Future<void> addChick({
    required String name,
    required double price,
    required String updatedBy,
    String category = 'fattening',
  });
  Future<void> updateChick({
    required String id,
    required String name,
    required double price,
    required String updatedBy,
    String category = 'fattening',
  });
  Future<void> toggleChickStatus({required String id, required bool isActive, required String updatedBy});
  Future<void> deleteChick(String id);
}

class ChicksRemoteDataSourceImpl implements ChicksRemoteDataSource {
  final FirebaseFirestore firestore;
  static const String collection = 'chicks_prices';

  ChicksRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ChickProductModel>> getActiveChicks() async {
    final snap = await firestore
        .collection(collection)
        .get()
        .timeout(const Duration(seconds: 10));
    final items = snap.docs
        .map(ChickProductModel.fromFirestore)
        .where((c) => c.isActive)
        .toList();
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  @override
  Future<List<ChickProductModel>> getAllChicks() async {
    final snap = await firestore
        .collection(collection)
        .get()
        .timeout(const Duration(seconds: 10));
    final items = snap.docs.map(ChickProductModel.fromFirestore).toList();
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  @override
  Future<void> addChick({
    required String name,
    required double price,
    required String updatedBy,
    String category = 'fattening',
  }) async {
    int count = 0;
    try {
      count = (await firestore.collection(collection).count().get().timeout(const Duration(seconds: 4))).count ?? 0;
    } catch (_) {
      count = 0;
    }
    await firestore.collection(collection).add({
      'name': name,
      'price': price.ceilToDouble(),
      'category': category,
      'isActive': true,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
      'order': count,
    });
  }

  @override
  Future<void> updateChick({
    required String id,
    required String name,
    required double price,
    required String updatedBy,
    String category = 'fattening',
  }) async {
    await firestore.collection(collection).doc(id).update({
      'name': name,
      'price': price.ceilToDouble(),
      'category': category,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }

  @override
  Future<void> toggleChickStatus({required String id, required bool isActive, required String updatedBy}) async {
    await firestore.collection(collection).doc(id).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }

  @override
  Future<void> deleteChick(String id) async {
    await firestore.collection(collection).doc(id).delete();
  }
}
