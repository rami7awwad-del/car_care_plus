import 'package:flutter/material.dart';

/// اللغة الافتراضية هي العربية
/// مصدر واحد للحقيقة (single source of truth) للغة التطبيق.
ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('ar'));

/// وضع الثيم (فاتح / داكن / حسب النظام) — نفس نمط [appLocale].
ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.system);

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

  static String get fullName => isArabic ? 'الاسم الكامل' : 'Full Name';

  static String get password => isArabic ? 'كلمة المرور' : 'Password';

  static String get confirmPassword => isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password';

  static String get forgotPassword => isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?';

  static String get noAccount => isArabic ? 'ليس لديك حساب؟ إنشاء حساب' : "Don't have an account? Sign Up";

  static String get otpVerification => isArabic ? 'التحقق من الرمز' : 'OTP Verification';

  static String get verify => isArabic ? 'تحقق' : 'Verify';

  static String get resendCode => isArabic ? 'إعادة إرسال الرمز' : 'Resend Code';

  static String get allFieldsRequired => isArabic ? 'يرجى إدخال جميع البيانات' : 'Please fill in all fields';

  static String get passwordsNotMatch => isArabic ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match';

  static String get invalidOtp => isArabic ? 'أدخل رمز OTP صحيح' : 'Enter a valid OTP code';

  static String get otpVerified => isArabic ? 'تم التحقق بنجاح' : 'Verification successful';

  static String get loginSuccess => isArabic ? 'تم تسجيل الدخول بنجاح' : 'Logged in successfully';

  static String get registerSuccess =>
      isArabic ? 'تم تسجيل البيانات.. جاري الانتقال للتحقق' : 'Registered.. moving to verification';

  static String otpSentTo(String phone) =>
      isArabic ? 'تم إرسال رمز التحقق إلى $phone' : 'Verification code sent to $phone';

  // ── Road Assistance ──────────────────────────────────────────────
  static String get roadAssistance => isArabic ? 'المساعدة على الطريق' : 'Road Assistance';
  static String get emergencyRequest => isArabic ? 'طلب مساعدة طارئة' : 'Emergency Request';
  static String get emergencySubtitle =>
      isArabic ? 'دعم فوري على الطريق خلال دقائق' : 'Instant roadside support in minutes';

  // خطوات
  static String get stepService => isArabic ? 'نوع الخدمة' : 'Service';
  static String get stepDetails => isArabic ? 'التفاصيل' : 'Details';
  static String get stepLocation => isArabic ? 'الموقع' : 'Location';
  static String get stepReview => isArabic ? 'المراجعة' : 'Review';
  static String get next => isArabic ? 'التالي' : 'Next';
  static String get back => isArabic ? 'السابق' : 'Back';
  static String get requestHelp => isArabic ? 'اطلب المساعدة' : 'Request Help';

  // فئات الخدمة (PRD)
  static String get catGeneral => isArabic ? 'فحص عام' : 'General';
  static String get catMechanical => isArabic ? 'ميكانيك' : 'Mechanical';
  static String get catElectrical => isArabic ? 'كهرباء' : 'Electrical';
  static String get catFuel => isArabic ? 'وقود' : 'Fuel';
  static String get catTires => isArabic ? 'إطارات' : 'Tires';
  static String get catTowing => isArabic ? 'سطحة' : 'Towing';
  static String get selectServiceFirst => isArabic ? 'يرجى اختيار نوع الخدمة' : 'Please select a service type';

  // درجة الخطورة
  static String get severity => isArabic ? 'درجة الخطورة' : 'Severity';
  static String get sevSimple => isArabic ? 'بسيطة' : 'Simple';
  static String get sevMedium => isArabic ? 'متوسطة' : 'Medium';
  static String get sevUrgent => isArabic ? 'طارئة' : 'Urgent';

  // نوع السيارة
  static String get carType => isArabic ? 'نوع السيارة' : 'Car Type';
  static String get carSmall => isArabic ? 'صغيرة' : 'Small';
  static String get carSuv => 'SUV';
  static String get carTruck => isArabic ? 'شاحنة' : 'Truck';

  // وصف وصورة وموقع
  static String get problemDescription => isArabic ? 'وصف المشكلة (اختياري)' : 'Problem description (optional)';
  static String get addPhoto => isArabic ? 'إضافة صورة (اختياري)' : 'Add photo (optional)';
  static String get photoHint =>
      isArabic ? 'صورة المشكلة تساعد الفني على الاستعداد مسبقاً' : 'A photo helps the technician prepare';
  static String get locateMe => isArabic ? 'تحديد موقعي' : 'Locate Me';
  static String get locationDetected => isArabic ? 'تم تحديد موقعك بنجاح' : 'Your location has been detected';
  static String get locationRequired => isArabic ? 'يرجى تحديد موقعك أولاً' : 'Please set your location first';

  // السعر
  static String get estimatedPrice => isArabic ? 'السعر التقديري' : 'Estimated Price';
  static String get currency => isArabic ? 'ر.س' : 'SAR';
  static String get basePrice => isArabic ? 'السعر الأساسي' : 'Base price';
  static String get total => isArabic ? 'الإجمالي' : 'Total';
  static String get requestSummary => isArabic ? 'ملخص الطلب' : 'Request Summary';

  // التتبع
  static String get trackingTitle => isArabic ? 'تتبع المساعدة' : 'Assistance Tracking';
  static String get requestSent => isArabic ? 'تم إرسال طلب المساعدة' : 'Your assistance request has been sent';
  static String get statusSearching => isArabic ? 'جارٍ البحث عن أقرب فني...' : 'Finding the nearest technician...';
  static String get statusAssigned => isArabic ? 'تم تعيين فني لك' : 'A technician is assigned';
  static String get statusEnRoute => isArabic ? 'الفني في الطريق إليك' : 'Technician on the way';
  static String get statusArrived => isArabic ? 'وصل الفني إلى موقعك' : 'Technician has arrived';
  static String get statusInProgress => isArabic ? 'جارٍ تنفيذ الخدمة' : 'Service in progress';
  static String get statusCompleted => isArabic ? 'تم إنجاز الخدمة بنجاح' : 'Service completed';
  static String get technician => isArabic ? 'الفني' : 'Technician';
  static String get callTechnician => isArabic ? 'اتصال' : 'Call';
  static String get cancelRequest => isArabic ? 'إلغاء الطلب' : 'Cancel Request';
  static String get cancelWindowHint =>
      isArabic ? 'يمكن الإلغاء خلال هذه الفترة القصيرة فقط' : 'Cancellation is only allowed during this short window';
  static String get requestCancelled => isArabic ? 'تم إلغاء الطلب' : 'Request cancelled';
  static String get rateService => isArabic ? 'قيّم الخدمة' : 'Rate the service';
  static String etaMinutes(int m) => isArabic ? 'الوصول خلال $m دقيقة' : 'Arrives in $m min';
}
