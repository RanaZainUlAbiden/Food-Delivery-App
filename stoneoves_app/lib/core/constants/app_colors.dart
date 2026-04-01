import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFFE63946);      // Red — main brand color
  static const Color primaryDark = Color(0xFFC1121F);  // Dark red
  static const Color secondary = Color(0xFF1D1D1D);    // Almost black

  // Background Colors
  static const Color background = Color(0xFFF8F8F8);   // Light gray bg
  static const Color surface = Color(0xFFFFFFFF);      // White cards
  static const Color bottomNav = Color(0xFFFFFFFF);    // White bottom bar

  // Text Colors
  static const Color textPrimary = Color(0xFF1D1D1D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Utility
  static const Color divider = Color(0xFFEEEEEE);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE63946), Color(0xFFC1121F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}