import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/egg_product_model.dart';

abstract class EggsRemoteDataSource {
  Future<List<EggProductModel>> getActiveEggs();
  Future<List<EggProductModel>> getAllEggs();
  Future<void> addEgg({required String name, required double price, required String updatedBy});
  Future<void> updateEgg({required String id, required String name, required double price, required String updatedBy});
  Future<void> toggleEggStatus({required String id, required bool isActive, required String updatedBy});
  Future<void> deleteEgg(String id);
}

class EggsRemoteDataSourceImpl implements EggsRemoteDataSource {
  final FirebaseFirestore firestore;
  static const String collection = 'eggs_prices';

  EggsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<EggProductModel>> getActiveEggs() async {
    final snap = await firestore
        .collection(collection)
        .get()
        .timeout(const Duration(seconds: 10));
    final items = snap.docs
        .map(EggProductModel.fromFirestore)
        .where((e) => e.isActive)
        .toList();
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  @override
  Future<List<EggProductModel>> getAllEggs() async {
    final snap = await firestore
        .collection(collection)
        .get()
        .timeout(const Duration(seconds: 10));
    final items = snap.docs.map(EggProductModel.fromFirestore).toList();
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  @override
  Future<void> addEgg({required String name, required double price, required String updatedBy}) async {
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
  Future<void> updateEgg({required String id, required String name, required double price, required String updatedBy}) async {
    await firestore.collection(collection).doc(id).update({
      'name': name,
      'price': price.ceilToDouble(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }

  @override
  Future<void> toggleEggStatus({required String id, required bool isActive, required String updatedBy}) async {
    await firestore.collection(collection).doc(id).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }

  @override
  Future<void> deleteEgg(String id) async {
    await firestore.collection(collection).doc(id).delete();
  }
}
