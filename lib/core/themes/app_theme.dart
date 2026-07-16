import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/spacing.dart';

/// نظام الثيم — يُبنى من الـ design tokens في core/constants.
/// يدعم الوضع الفاتح والداكن مع خط Cairo المناسب للعربية.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  // واجهة متوافقة مع الاستخدام القديم
  static ThemeData getLightTheme() => light;
  static ThemeData getDarkTheme() => dark;

  static ThemeData _build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final ThemeData base = ThemeData(brightness: brightness, useMaterial3: true);

    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    );

    final Color scaffoldBg = isDark ? const Color(0xFF0F172A) : AppColors.background;
    final Color surface = isDark ? const Color(0xFF1E293B) : AppColors.surface;
    final Color fieldFill = isDark ? const Color(0xFF1E293B) : AppColors.surface;

    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: GoogleFonts.cairoTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: surface,
        elevation: Spacing.elevationLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Spacing.radiusLg)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        border: border(AppColors.border),
        enabledBorder: border(AppColors.border),
        focusedBorder: border(AppColors.primary, 2),
        errorBorder: border(AppColors.error),
        focusedErrorBorder: border(AppColors.error, 2),
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.lg),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(55),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Spacing.radiusXl)),
          textStyle: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
    );
  }
}
