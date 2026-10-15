// ============================================================
// seed_firestore.dart — Standalone seed script
// Run with: flutter run -t tool/seed_firestore.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:elshams/firebase_options.dart';
import 'package:elshams/core/constants/firebase_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await seedData();
  debugPrint('Done!');
}

Future<void> seedData() async {
  final db = FirebaseFirestore.instance;

  final settingsRef = db
      .collection(FirebaseConstants.settingsCollection)
      .doc(FirebaseConstants.livePriceDoc);

  final existing = await settingsRef.get();
  if (!existing.exists) {
    await settingsRef.set({
      'livePrice': 100.0,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': 'system-seed',
    });
    debugPrint('Live price seeded');
  } else {
    debugPrint('Live price already exists');
  }

  final products = [
    {'name': 'فراخ كاملة', 'multiplier': 1.60, 'increase': 25.0, 'order': 0},
    {'name': 'صدور بالعظم', 'multiplier': 1.55, 'increase': 25.0, 'order': 1},
    {'name': 'ورك عادة', 'multiplier': 1.25, 'increase': 20.0, 'order': 2},
    {'name': 'ورك مقصف', 'multiplier': 1.45, 'increase': 25.0, 'order': 3},
    {'name': 'دبوس', 'multiplier': 1.30, 'increase': 20.0, 'order': 4},
    {'name': 'شيش بالجلد', 'multiplier': 1.65, 'increase': 30.0, 'order': 5},
    {'name': 'شيش كامل بدون جلد', 'multiplier': 1.80, 'increase': 30.0, 'order': 6},
    {'name': 'فيليه', 'multiplier': 2.95, 'increase': 25.0, 'order': 7},
    {'name': 'شاورما مسحب', 'multiplier': 2.10, 'increase': 25.0, 'order': 8},
    {'name': 'صدور فيليه بالجلد', 'multiplier': 2.70, 'increase': 25.0, 'order': 9},
  ];

  final productsRef = db.collection(FirebaseConstants.productsCollection);
  final existingProducts = await productsRef.limit(1).get();

  if (existingProducts.docs.isEmpty) {
    final batch = db.batch();
    for (final p in products) {
      final ref = productsRef.doc();
      batch.set(ref, {
        ...p,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': 'system-seed',
        'updatedBy': 'system-seed',
      });
    }
    await batch.commit();
    debugPrint('${products.length} products seeded');
  } else {
    debugPrint('Products already exist');
  }
}
