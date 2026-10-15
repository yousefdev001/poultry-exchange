// ============================================================
// date_formatter.dart — تنسيق التواريخ بالعربية
// ============================================================

import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final _timeFormat = DateFormat('hh:mm a', 'ar');
  static final _dateFormat = DateFormat('d MMMM yyyy', 'ar');
  static final _dateTimeFormat = DateFormat('d MMMM yyyy — hh:mm a', 'ar');
  static final _todayFullFormat = DateFormat('EEEE، d MMMM yyyy', 'ar');

  /// يعرض اليوم بالكامل: السبت، 12 سبتمبر 2026
  static String formatTodayFull() {
    return _todayFullFormat.format(DateTime.now());
  }

  /// يعرض: اليوم، 04:35 م  أو  12 سبتمبر 2026، 04:35 م
  static String formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'اليوم، ${_timeFormat.format(dateTime)}';
    } else {
      return _dateTimeFormat.format(dateTime);
    }
  }

  /// يعرض: 12 سبتمبر 2026 — 04:35 م
  static String formatFull(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// يعرض: 12 سبتمبر 2026
  static String formatDate(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }

  /// يعرض: 04:35 م
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }
}

