// ============================================================
// price_calculator.dart — معادلة الحساب المركزية الوحيدة
// FINAL PRICE = LIVE PRICE × MULTIPLIER + INCREASE
// ============================================================

class PriceCalculator {
  PriceCalculator._();

  /// يحسب السعر النهائي للمنتج
  /// [livePrice] سعر اللحم الحي
  /// [multiplier] نسبة الضرب
  /// [increase] قيمة الزيادة الثابتة
  /// يُرجع السعر النهائي مقرّبًا لأقرب 0.5
  static double calculateFinalPrice({
    required double livePrice,
    required double multiplier,
    required double increase,
  }) {
    assert(livePrice >= 0, 'سعر الحي لا يمكن أن يكون سالبًا');
    assert(multiplier > 0, 'النسبة يجب أن تكون أكبر من صفر');
    assert(increase >= 0, 'الزيادة لا يمكن أن تكون سالبة');

    final rawPrice = (livePrice * multiplier) + increase;
    return rawPrice.ceilToDouble();
  }

  /// التحقق من صحة سعر الحي
  static bool isValidLivePrice(double price) {
    return price > 0 && price <= 10000;
  }

  /// التحقق من صحة النسبة
  static bool isValidMultiplier(double multiplier) {
    return multiplier > 0 && multiplier <= 100;
  }

  /// التحقق من صحة الزيادة
  static bool isValidIncrease(double increase) {
    return increase >= 0 && increase <= 10000;
  }
}
