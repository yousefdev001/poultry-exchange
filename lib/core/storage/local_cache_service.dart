// ============================================================
// local_cache_service.dart — خدمة التخزين المحلي
// ============================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  static const String _livePriceKey = 'cached_live_price';
  static const String _productsKey = 'cached_products';
  static const String _lastUpdatedKey = 'cached_last_updated';

  final SharedPreferences _prefs;

  LocalCacheService(this._prefs);

  // ---- Live Price ----

  Future<void> cacheLivePrice(Map<String, dynamic> livePriceData) async {
    await _prefs.setString(_livePriceKey, json.encode(livePriceData));
  }

  Map<String, dynamic>? getCachedLivePrice() {
    final data = _prefs.getString(_livePriceKey);
    if (data == null) return null;
    return json.decode(data) as Map<String, dynamic>;
  }

  // ---- Products ----

  Future<void> cacheProducts(List<Map<String, dynamic>> products) async {
    await _prefs.setString(_productsKey, json.encode(products));
  }

  List<Map<String, dynamic>>? getCachedProducts() {
    final data = _prefs.getString(_productsKey);
    if (data == null) return null;
    final decoded = json.decode(data) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  // ---- Last Updated ----

  Future<void> saveLastUpdated(DateTime dateTime) async {
    await _prefs.setString(_lastUpdatedKey, dateTime.toIso8601String());
  }

  DateTime? getLastUpdated() {
    final data = _prefs.getString(_lastUpdatedKey);
    if (data == null) return null;
    return DateTime.tryParse(data);
  }

  // ---- Clear ----

  Future<void> clearAll() async {
    await _prefs.remove(_livePriceKey);
    await _prefs.remove(_productsKey);
    await _prefs.remove(_lastUpdatedKey);
  }

  bool get hasCache =>
      _prefs.containsKey(_livePriceKey) && _prefs.containsKey(_productsKey);
}
