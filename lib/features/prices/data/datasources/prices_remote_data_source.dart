import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/live_price_model.dart';
import '../models/product_model.dart';

abstract class PricesRemoteDataSource {
  Future<LivePriceModel> getLivePrice();
  Future<List<ProductModel>> getActiveProducts();
}

class PricesRemoteDataSourceImpl implements PricesRemoteDataSource {
  final FirebaseFirestore firestore;
  PricesRemoteDataSourceImpl({required this.firestore});

  @override
  Future<LivePriceModel> getLivePrice() async {
    try {
      final doc = await firestore
          .collection(FirebaseConstants.settingsCollection)
          .doc(FirebaseConstants.livePriceDoc)
          .get()
          .timeout(const Duration(seconds: 10));
      if (!doc.exists || doc.data() == null) {
        throw const NotFoundException('سعر اللحم الحي غير موجود');
      }
      return LivePriceModel.fromMap(doc.data()!);
    } on NotFoundException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'خطأ في الاتصال بالخادم');
    }
  }

  @override
  Future<List<ProductModel>> getActiveProducts() async {
    try {
      final query = await firestore
          .collection(FirebaseConstants.productsCollection)
          .get()
          .timeout(const Duration(seconds: 10));
      final products = query.docs
          .map(ProductModel.fromFirestore)
          .where((p) => p.isActive)
          .toList();
      products.sort((a, b) => a.order.compareTo(b.order));
      return products;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'خطأ في تحميل الأصناف');
    }
  }
}
