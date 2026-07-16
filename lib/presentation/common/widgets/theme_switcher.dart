import 'package:flutter/material.dart';

import 'package:car_care_plus/app/app_language.dart';

/// زر تبديل الثيم (فاتح/داكن). يعتمد على [appThemeMode] كمصدر للحقيقة.
class ThemeSwitcher extends StatelessWidget {
  /// لون الأيقونة — مفيد عند وضعه فوق شريط ملوّن (AppBar).
  final Color? color;

  const ThemeSwitcher({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, mode, _) {
        // نعتبر الوضع الحالي داكناً إذا اختير Dark صراحةً أو كان النظام داكناً.
        final bool isDark = mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        return IconButton(
          tooltip: isDark ? 'الوضع الفاتح' : 'الوضع الداكن',
          color: color,
          icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          onPressed: () {
            appThemeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
          },
        );
      },
    );
  }
}
