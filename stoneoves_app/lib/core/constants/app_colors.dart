import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFFE31837);      // Domino's style Red
  static const Color primaryDark = Color(0xFFB5122A);  // Dark red
  static const Color primaryLight = Color(0xFFFF4D6D); // Light red
  static const Color secondary = Color(0xFF1D1D1D);    // Almost black

  // Background Colors
  static const Color background = Color(0xFFF8F8F8);   // Light gray bg
  static const Color surface = Color(0xFFFFFFFF);      // White cards
  static const Color bottomNav = Color(0xFFFFFFFF);    // White bottom bar

  // Text Colors
  static const Color textPrimary = Color(0xFF1D1D1D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFF9E9E9E);

  // Utility Colors
  static const Color divider = Color(0xFFEEEEEE);
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE31837), Color(0xFFB5122A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1D1D1D), Color(0xFF0A0A0A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFF4D6D), Color(0xFFE31837)],  // ✅ Fixed
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Transparent/Opacity Colors
  static Color primaryWithOpacity(double opacity) => primary.withOpacity(opacity);
  static Color textPrimaryWithOpacity(double opacity) => textPrimary.withOpacity(opacity);
  static Color blackOverlay = Colors.black.withOpacity(0.5);
  static Color whiteOverlay = Colors.white.withOpacity(0.8);
  static Color shimmerBase = Colors.grey.shade300;
  static Color shimmerHighlight = Colors.grey.shade100;

  // Status Colors (with light backgrounds for chips)
  static const Map<String, Color> orderStatusColors = {
    'PENDING': warning,
    'CONFIRMED': info,
    'PREPARING': info,
    'READY': success,
    'DELIVERED': success,
    'CANCELLED': error,
  };

  static const Map<String, Color> orderStatusBackgrounds = {
    'PENDING': warningLight,
    'CONFIRMED': infoLight,
    'PREPARING': infoLight,
    'READY': successLight,
    'DELIVERED': successLight,
    'CANCELLED': errorLight,
  };
}

// Box Shadows
class AppShadows {
  static const BoxShadow subtle = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow light = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 12,
    offset: Offset(0, 3),
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow floating = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  static const BoxShadow heavy = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 32,
    offset: Offset(0, 12),
  );

  static const BoxShadow primaryGlow = BoxShadow(
    color: Color(0x40E31837),  // ✅ Fixed - 25% opacity Domino's red
    blurRadius: 20,
    offset: Offset(0, 4),
  );

  static List<BoxShadow> get cardShadow => [subtle, light];
  static List<BoxShadow> get buttonShadow => [medium];
  static List<BoxShadow> get floatingButtonShadow => [floating];
}