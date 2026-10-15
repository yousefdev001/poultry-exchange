// ============================================================
// price_formatter.dart — تنسيق عرض الأسعار
// ============================================================

class PriceFormatter {
  PriceFormatter._();

  /// يعرض السعر بصيغة: 131 جنيه أو 131.50 جنيه
  static String format(double price) {
    if (price == price.truncateToDouble()) {
      return '${price.toInt()} جنيه';
    }
    return '${price.toStringAsFixed(2)} جنيه';
  }

  /// يعرض السعر بدون عملة: 131
  static String formatNumber(double price) {
    if (price == price.truncateToDouble()) {
      return price.toInt().toString();
    }
    return price.toStringAsFixed(2);
  }

  /// يحوّل النص لرقم أو null
  static double? parse(String value) {
    return double.tryParse(value.trim());
  }
}
