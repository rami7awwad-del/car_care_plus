import 'package:flutter/material.dart';

/// اللغة الافتراضية هي العربية
ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('ar'));

class AppStrings {
  static bool get isArabic => appLocale.value.languageCode == 'ar';

  static String get welcome => isArabic ? 'مرحباً بك' : 'Welcome';

  static String get welcomeDescription => isArabic
      ? 'استمتع بتجربة سهلة وسريعة للوصول إلى جميع خدمات التطبيق'
      : 'Enjoy an easy and fast experience to access all app services.';

  static String get getStarted => isArabic ? 'ابدأ الآن' : 'Get Started';

  static String get login => isArabic ? 'تسجيل الدخول' : 'Login';

  static String get createAccount => isArabic ? 'إنشاء حساب' : 'Create Account';

  static String get emailOrPhone => isArabic ? 'البريد الإلكتروني أو رقم الهاتف' : 'Email or Phone Number';

  static String get email => isArabic ? 'البريد الإلكتروني' : 'Email';

  static String get phone => isArabic ? 'رقم الهاتف' : 'Phone Number';

  static String get password => isArabic ? 'كلمة المرور' : 'Password';

  static String get confirmPassword => isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password';

  static String get noAccount => isArabic ? 'ليس لديك حساب؟ إنشاء حساب' : "Don't have an account? Sign Up";

  static String get otpVerification => isArabic ? 'التحقق من الرمز' : 'OTP Verification';

  static String get verify => isArabic ? 'تحقق' : 'Verify';

  static String get resendCode => isArabic ? 'إعادة إرسال الرمز' : 'Resend Code';

  static String get allFieldsRequired => isArabic ? 'يرجى إدخال جميع البيانات' : 'Please fill in all fields';

  static String get passwordsNotMatch => isArabic ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match';

  static String get invalidOtp => isArabic ? 'أدخل رمز OTP صحيح' : 'Enter a valid OTP code';

  static String get otpVerified => isArabic ? 'تم التحقق بنجاح' : 'Verification successful';

  static String otpSentTo(String phone) =>
      isArabic ? 'تم إرسال رمز التحقق إلى $phone' : 'Verification code sent to $phone';
}
