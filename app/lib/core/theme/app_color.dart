import 'package:flutter/material.dart';

/// High-contrast red/white accessibility-first color palette
class AppColors {
  AppColors._();

  // Primary
  static const Color red = Color(0xFFD32F2F);
  static const Color redDark = Color(0xFFB71C1C);
  static const Color redLight = Color(0xFFEF5350);

  // Backgrounds
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F2F2);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textOnRed = Color(0xFFFFFFFF);

  // Accent colors for service types
  static const Color police = Color(0xFF1565C0);
  static const Color hospital = Color(0xFFD32F2F);
  static const Color fire = Color(0xFFE65100);
  static const Color ambulance = Color(0xFFF9A825);

  // Misc
  static const Color border = Color(0xFFDDDDDD);
  static const Color shadow = Color(0x1A000000);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57F17);
}
