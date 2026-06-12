import 'package:flutter/material.dart';

// اسم التطبيق، الإصدار...
class AppConstants {
  static const String appName = 'Car Care Plus';
  static const String appVersion = '1.0.0';
}

class AppColors {
  // الألوان الأساسية - مستوحاة من خدمات السيارات
  static const primary = Color(0xFF1A73E8); // أزرق رئيسي
  static const primaryDark = Color(0xFF0D47A1); // أزرق غامق
  static const secondary = Color(0xFF00BCD4); // فيروزي للإشعارات
  static const accent = Color(0xFFFF6B35); // برتقالي للأزرار المهمة

  // ألوان النجاح والخطأ والتحذير
  static const success = Color(0xFF4CAF50); // أخضر
  static const error = Color(0xFFE53935); // أحمر
  static const warning = Color(0xFFFFC107); // أصفر
  static const info = Color(0xFF2196F3); // أزرق فاتح

  // ألوان الخلفية
  static const background = Color(0xFFF5F5F5); // خلفية فاتحة
  static const backgroundDark = Color(0xFF121212); // خلفية داكنة
  static const surface = Color(0xFFFFFFFF); // سطح أبيض
  static const surfaceDark = Color(0xFF1E1E1E); // سطح داكن

  // ألوان النصوص
  static const textPrimary = Color(0xFF212121); // نص رئيسي
  static const textSecondary = Color(0xFF757575); // نص ثانوي
  static const textDisabled = Color(0xFFBDBDBD); // نص معطل
  static const textLight = Color(0xFFFFFFFF); // نص فاتح

  // ألوان الحدود والفواصل
  static const border = Color(0xFFE0E0E0);
  static const divider = Color(0xFFEEEEEE);
}
