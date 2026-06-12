# TODO

- [ ] إصلاح أخطاء `lib/presentation/customer/auth/pages/welcome_page.dart` التي ظهرت في `flutter analyze`.
  - [ ] تعديل الاستيراد من `app/app_strings.dart` إلى المسار الصحيح (أو استخدام `package:car_care_plus/...`).
  - [ ] إصلاح `appLocale` غير المعرف (import الصحيح لـ `app_language.dart` أو نقل الاستخدام).
  - [ ] إصلاح مشاكل النوع/Nullable في `DropdownButton<Locale>`.
  - [ ] إزالة متغير `isArabic` غير المستخدم أو توحيد تعريفه.
- [ ] إعادة تشغيل `flutter analyze` للتأكد من اختفاء الأخطاء.

