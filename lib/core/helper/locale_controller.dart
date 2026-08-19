import 'package:flutter/material.dart';

import 'shared_pref_helper.dart';

/// يتحكّم بلغة التطبيق ويحفظ اختيار المستخدم بين الجلسات.
///
/// يُوفَّر فوق الـ MaterialApp، فأي تغيير هنا يُعيد بناء التطبيق كاملاً
/// ويقلب اتجاه الواجهة تلقائياً بين RTL و LTR
class LocaleController extends ChangeNotifier {
  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');

  /// رمز اللغة الحالي بصيغة ثابتة يقرأها DioFactory ليضبط ترويسة
  /// `Accept-Language`، لأن الـ Interceptor لا يملك BuildContext
  static String currentLanguageCode = arabic.languageCode;

  Locale _locale = arabic;

  Locale get locale => _locale;

  bool get isArabic => _locale.languageCode == arabic.languageCode;

  /// تُستدعى مرة عند الإقلاع لاستعادة اللغة المحفوظة
  Future<void> loadSavedLocale() async {
    final saved = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.appLocale,
    );
    if (saved.isEmpty || saved == _locale.languageCode) return;

    _locale = Locale(saved);
    currentLanguageCode = saved;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == _locale.languageCode) return;

    _locale = locale;
    currentLanguageCode = locale.languageCode;
    notifyListeners();

    await SharedPrefHelper.setSecuredString(
      SharedPrefKeys.appLocale,
      locale.languageCode,
    );
  }

  Future<void> toggle() => setLocale(isArabic ? english : arabic);
}
