import 'package:flutter/material.dart';

class AirinColors {
  // Brand Teal
  static const Color tealBrand = Color(0xFF0D9488); // oklch(70.4% 0.14 182.503) approx
  static const Color tealBrandDark = Color(0xFF0F766E); // oklch(52% 0.14 182.503)
  static const Color tealBrandLight = Color(0xFFCCFBF1);
  static const Color tealBrandBorder = Color(0xFF99F6E4);

  // Dark Mode Colors
  static const Color darkBg = Color(0xFF121214);
  static const Color darkCard = Color(0xFF18181B);
  static const Color darkCardElevated = Color(0xFF202024);
  static const Color darkCardSecondary = Color(0xFF27272A);
  static const Color darkBorder = Color(0x1AFFFFFF); // white/10
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextMuted = Color(0xFF71717A);

  // Light Mode Colors
  static const Color lightBg = Color(0xFFFBFBFD);
  static const Color lightSecondaryBg = Color(0xFFF5F5F7);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0x14000000); // black/[0.08]
  static const Color lightTextPrimary = Color(0xFF1D1D1F);
  static const Color lightTextSecondary = Color(0xFF6E6E73);
  static const Color lightTextMuted = Color(0xFF86868B);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);
}

class AirinTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AirinColors.lightBg,
      primaryColor: AirinColors.tealBrand,
      colorScheme: const ColorScheme.light(
        primary: AirinColors.tealBrand,
        secondary: AirinColors.tealBrandDark,
        surface: AirinColors.lightCard,
        error: AirinColors.error,
      ),
      cardTheme: CardTheme(
        color: AirinColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AirinColors.lightBorder),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AirinColors.lightBg,
        foregroundColor: AirinColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      fontFamily: null,
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AirinColors.darkBg,
      primaryColor: AirinColors.tealBrand,
      colorScheme: const ColorScheme.dark(
        primary: AirinColors.tealBrand,
        secondary: AirinColors.tealBrandLight,
        surface: AirinColors.darkCard,
        error: AirinColors.error,
      ),
      cardTheme: CardTheme(
        color: AirinColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AirinColors.darkBorder),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AirinColors.darkBg,
        foregroundColor: AirinColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      fontFamily: null,
      useMaterial3: true,
    );
  }
}

