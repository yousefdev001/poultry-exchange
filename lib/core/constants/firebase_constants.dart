// ============================================================
// firebase_constants.dart — ثوابت Firestore
// ============================================================

class FirebaseConstants {
  FirebaseConstants._();

  // Collections
  static const String settingsCollection = 'settings';
  static const String productsCollection = 'products';
  static const String usersCollection = 'users';
  static const String auditLogsCollection = 'audit_logs';

  // Documents
  static const String livePriceDoc = 'live_price';

  // Fields — Settings
  static const String livePriceField = 'livePrice';
  static const String updatedAtField = 'updatedAt';
  static const String updatedByField = 'updatedBy';

  // Fields — Products
  static const String nameField = 'name';
  static const String multiplierField = 'multiplier';
  static const String increaseField = 'increase';
  static const String isActiveField = 'isActive';
  static const String categoryField = 'category';
  static const String createdAtField = 'createdAt';
  static const String createdByField = 'createdBy';
  static const String orderField = 'order';

  // Fields — Audit Log
  static const String actionField = 'action';
  static const String entityTypeField = 'entityType';
  static const String entityIdField = 'entityId';
  static const String oldValueField = 'oldValue';
  static const String newValueField = 'newValue';
  static const String performedByField = 'performedBy';
  static const String performedAtField = 'performedAt';

  // Fields — User
  static const String emailField = 'email';
  static const String roleField = 'role';

  // Roles
  static const String adminRole = 'admin';

  // Custom Claims
  static const String roleClaimKey = 'role';
}
