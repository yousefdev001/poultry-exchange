import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_cache_service.dart';
import '../models/live_price_model.dart';
import '../models/product_model.dart';

abstract class PricesLocalDataSource {
  Future<void> cacheLivePrice(LivePriceModel livePrice);
  Future<void> cacheProducts(List<ProductModel> products);
  LivePriceModel? getCachedLivePrice();
  List<ProductModel>? getCachedProducts();
  bool get hasCache;
}

class PricesLocalDataSourceImpl implements PricesLocalDataSource {
  final LocalCacheService cacheService;
  PricesLocalDataSourceImpl({required this.cacheService});

  @override
  Future<void> cacheLivePrice(LivePriceModel livePrice) async {
    try {
      await cacheService.cacheLivePrice(livePrice.toMap());
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      await cacheService.cacheProducts(products.map((p) => p.toCacheMap()).toList());
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  LivePriceModel? getCachedLivePrice() {
    final data = cacheService.getCachedLivePrice();
    if (data == null) return null;
    return LivePriceModel.fromCacheMap(data);
  }

  @override
  List<ProductModel>? getCachedProducts() {
    final data = cacheService.getCachedProducts();
    if (data == null) return null;
    return data.map(ProductModel.fromCacheMap).toList();
  }

  @override
  bool get hasCache => cacheService.hasCache;
}
