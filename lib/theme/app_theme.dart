// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFFF7A00);
  static const Color primaryDark = Color(0xFFE76700);
  static const Color primarySoft = Color(0xFFFFF0E1);
  static const Color primaryLight = Color(0xFFFFD6B0);

  static const Color background = Color(0xFFFFF9F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color searchBg = Color(0xFFF4F1ED);
  static const Color softSurface = Color(0xFFFFF4E8);

  static const Color appBar = Color(0xFFFFF9F4);
  static const Color onAppBar = Color(0xFF241B12);
  static const Color textDark = Color(0xFF2B2118);
  static const Color textTitle = Color(0xFF181C2E);
  static const Color textBody = Color(0xFF4B4036);
  static const Color textGrey = Color(0xFF85786C);
  static const Color textLight = Color(0xFFB9AEA3);
  static const Color textHint = Color(0xFFD2C6BC);
  static const Color divider = Color(0xFFF0E1D3);
  static const Color star = Color(0xFFFFB800);
  static const Color tagBg = Color(0xFFFFFBF7);

  static const List<List<Color>> cardGradients = [
    [Color(0xFFFFB15C), Color(0xFFFF7A00)],
    [Color(0xFFEABB85), Color(0xFFD97706)],
    [Color(0xFFFFC887), Color(0xFFF97316)],
    [Color(0xFFF4B183), Color(0xFFEA580C)],
    [Color(0xFFF7C47F), Color(0xFFFF8A00)],
    [Color(0xFFFFB888), Color(0xFFFB923C)],
  ];
}

class AppTextStyles {
  static TextStyle get heading1 => GoogleFonts.nunito(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static TextStyle get heading2 => GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textTitle,
  );

  static TextStyle get heading3 => GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textBody,
  );

  static TextStyle get sectionTitle => GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textBody,
  );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textGrey,
  );

  static TextStyle get bodySmall => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textGrey,
  );

  static TextStyle get caption => GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );

  static TextStyle get navLabel => GoogleFonts.nunito(
    fontSize: 8,
    fontWeight: FontWeight.w700,
    color: AppColors.textHint,
  );
}

ThemeData appTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.surface,
      onPrimary: Colors.white,
      onSurface: AppColors.textDark,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  final textTheme = GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
    headlineLarge: AppTextStyles.heading1,
    headlineMedium: AppTextStyles.heading2,
    headlineSmall: AppTextStyles.heading3,
    titleLarge: AppTextStyles.sectionTitle,
    bodyLarge: AppTextStyles.bodyMedium,
    bodyMedium: AppTextStyles.bodySmall,
    bodySmall: AppTextStyles.caption,
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appBar,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.onAppBar),
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.onAppBar,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.searchBg,
      hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.tagBg,
      selectedColor: AppColors.primarySoft,
      side: const BorderSide(color: AppColors.divider),
      labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textDark),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}
