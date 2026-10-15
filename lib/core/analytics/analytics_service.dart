import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService with WidgetsBindingObserver {
  final FirebaseFirestore firestore;
  final SharedPreferences prefs;

  static const String _deviceIdKey = 'app_device_id';
  static const String _lastVisitDateKey = 'last_visit_date';

  Timer? _heartbeatTimer;
  late final String _deviceId;

  AnalyticsService({
    required this.firestore,
    required this.prefs,
  }) {
    _deviceId = _getOrCreateDeviceId();
    WidgetsBinding.instance.addObserver(this);
  }

  String _getOrCreateDeviceId() {
    var id = prefs.getString(_deviceIdKey);
    if (id == null) {
      id = 'dev_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000))}';
      prefs.setString(_deviceIdKey, id);
    }
    return id;
  }

  /// Start tracking presence and record visit
  Future<void> initSession() async {
    await _recordVisit();
    await _sendPresenceHeartbeat(true);

    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _sendPresenceHeartbeat(true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sendPresenceHeartbeat(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _sendPresenceHeartbeat(false);
    }
  }

  Future<void> _sendPresenceHeartbeat(bool isOnline) async {
    try {
      await firestore.collection('presence').doc(_deviceId).set({
        'deviceId': _deviceId,
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> _recordVisit() async {
    try {
      final now = DateTime.now();
      final todayStr = DateFormat('yyyy_MM_dd').format(now);
      final monthStr = DateFormat('yyyy_MM').format(now);

      final lastVisit = prefs.getString(_lastVisitDateKey);
      final todayDateOnly = DateFormat('yyyy-MM-dd').format(now);

      // Record visit once per day per device
      if (lastVisit != todayDateOnly) {
        prefs.setString(_lastVisitDateKey, todayDateOnly);

        await firestore.collection('analytics').doc('summary').set({
          'todayDate': todayDateOnly,
          'currentMonth': monthStr,
          'visits_$todayStr': FieldValue.increment(1),
          'visits_m_$monthStr': FieldValue.increment(1),
          'totalVisits': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (_) {}
  }

  /// Realtime stream of currently online active users
  Stream<int> getOnlineUsersCount() {
    return firestore
        .collection('presence')
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final now = DateTime.now();
      int count = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final lastSeenTs = data['lastSeen'] as Timestamp?;
        if (lastSeenTs != null) {
          final diff = now.difference(lastSeenTs.toDate());
          // Active in the last 3 minutes
          if (diff.inMinutes <= 3) {
            count++;
          }
        } else {
          count++;
        }
      }
      return count > 0 ? count : 1; // At least 1 if viewing
    }).handleError((_) => 1);
  }

  /// Realtime stream of Today's visits
  Stream<int> getTodayVisits() {
    final todayStr = DateFormat('yyyy_MM_dd').format(DateTime.now());
    return firestore
        .collection('analytics')
        .doc('summary')
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return 0;
      final data = doc.data()!;
      return (data['visits_$todayStr'] as num? ?? 0).toInt();
    }).handleError((_) => 0);
  }

  /// Realtime stream of This Month's visits
  Stream<int> getMonthlyVisits() {
    final monthStr = DateFormat('yyyy_MM').format(DateTime.now());
    return firestore
        .collection('analytics')
        .doc('summary')
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return 0;
      final data = doc.data()!;
      return (data['visits_m_$monthStr'] as num? ?? 0).toInt();
    }).handleError((_) => 0);
  }

  void dispose() {
    _heartbeatTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
}
