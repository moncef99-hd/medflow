import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors.
  static const primary = Color(0xFF2B50EC);
  static const primaryAlt = Color(0xFF3358F4);
  static const secondary = Color(0xFF3B5EF8);
  static const heroEnd = Color(0xFF2445D8);

  // Semantic colors.
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);

  // Accent colors.
  static const mint = Color(0xFF8CE89C);
  static const mintText = Color(0xFF0E4F1E);
  static const softBlue = Color(0xFFEEF1FF);
  static const softLavender = Color(0xFFEEF1FF);
  static const softPeriwinkle = Color(0xFFB8C7FC);

  // Light theme.
  static const lightBg = Color(0xFFF4F6FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF111827);
  static const lightMuted = Color(0xFF6B7280);
  static const lightBorder = Color(0xFFE5E9F2);

  // Dark theme.
  static const darkBg = Color(0xFF0B1220);
  static const darkSurface = Color(0xFF131C2E);
  static const darkText = Color(0xFFF1F5F9);
  static const darkMuted = Color(0xFF94A3B8);
  static const darkBorder = Color(0xFF29364D);

  // Shared surfaces.
  static const inactiveTrack = Color(0xFFE5E9F2);
  static const cardSurface = Color(0xFFFFFFFF);

  // Main brand gradient.
  static const gradient = LinearGradient(
    colors: [secondary, heroEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dashboard and hero headers.
  static const headerGradient = LinearGradient(
    colors: [Color(0xFF3B5EF8), Color(0xFF2445D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft ambient background gradient.
  static const canvasGradient = LinearGradient(
    colors: [Color(0xFF9AAEF9), Color(0xFFB8C7FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glass effect for buttons placed on blue headers.
  static const glassWhite = Color(0x29FFFFFF);
  static const glassBorder = Color(0x40FFFFFF);

  // Standard card shadow.
  static const cardShadow = [
    BoxShadow(color: Color(0x0D18274B), blurRadius: 24, offset: Offset(0, 8)),
  ];

  // Standard dimensions.
  static const cardRadius = 22.0;
  static const headerRadius = 28.0;
  static const buttonRadius = 16.0;
  static const pillRadius = 999.0;
}
