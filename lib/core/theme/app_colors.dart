// ============================================================
// app_colors.dart — ألوان التطبيق المستخرجة من شعار الشمس
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Primary: ذهبي (حافة الشعار والشمس) ---
  static const Color primary = Color(0xFFD4A017);
  static const Color primaryLight = Color(0xFFE8C455);
  static const Color primaryDark = Color(0xFFA87A00);

  // --- Secondary: برتقالي محمر (كلمة شمس) ---
  static const Color secondary = Color(0xFFE8620A);
  static const Color secondaryLight = Color(0xFFFF8A3D);
  static const Color secondaryDark = Color(0xFFB54000);

  // --- Accent: أخضر (الخطوط الخضراء في الشعار) ---
  static const Color accent = Color(0xFF2E7D32);
  static const Color accentLight = Color(0xFF60AD5E);
  static const Color accentDark = Color(0xFF005005);

  // --- Backgrounds ---
  static const Color background = Color(0xFFFAFAF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F0E8);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // --- Text ---
  static const Color textPrimary = Color(0xFF2C1A00);
  static const Color textSecondary = Color(0xFF6D4C00);
  static const Color textHint = Color(0xFF9E8060);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // --- Status ---
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color success = Color(0xFF388E3C);
  static const Color successLight = Color(0xFFC8E6C9);
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color info = Color(0xFF1565C0);

  // --- UI Elements ---
  static const Color divider = Color(0xFFE8DCC8);
  static const Color border = Color(0xFFD4C4A0);
  static const Color shadow = Color(0x1A2C1A00);
  static const Color overlay = Color(0x802C1A00);
  static const Color shimmerBase = Color(0xFFEDE8DC);
  static const Color shimmerHighlight = Color(0xFFF5F0E8);

  // --- Admin ---
  static const Color adminBackground = Color(0xFF1A1208);
  static const Color adminSurface = Color(0xFF2C1E0A);
  static const Color adminPrimary = Color(0xFFD4A017);
  static const Color activeStatus = Color(0xFF388E3C);
  static const Color inactiveStatus = Color(0xFF9E8060);

  // --- Price Display ---
  static const Color priceGold = Color(0xFFD4A017);
  static const Color priceBackground = Color(0xFFFFF8E1);
}

