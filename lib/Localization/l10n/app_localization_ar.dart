// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get session => 'الجلسة';

  @override
  String total(Object ammount) {
    return 'الإجمالي';
  }

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get welcomeBack => 'مرحباً بك مجدداً';

  @override
  String get loginSubtitle => 'سجّل الدخول لمتابعة خدمات العناية بسيارتك';

  @override
  String get emailOrPhone => 'البريد الإلكتروني أو رقم الهاتف';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get createNewAccount => 'إنشاء حساب جديد';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get createAccountTitle => 'إنشاء حساب جديد';

  @override
  String get createAccountSubtitle =>
      'انضم إلينا للاستفادة من أفضل خدمات العناية بالسيارة';

  @override
  String get individualAccount => 'حساب فرد';

  @override
  String get companyAccount => 'حساب الشركة';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get next => 'التالي';

  @override
  String get companyInfo => 'بيانات الشركة';

  @override
  String get companyInfoSubtitle => 'أدخل بيانات الشركة لاستكمال التسجيل';

  @override
  String get companyNameEn => 'اسم الشركة (بالإنجليزية)';

  @override
  String get companyNameAr => 'اسم الشركة (بالعربية)';

  @override
  String get commercialReg => 'رقم السجل التجاري';

  @override
  String get taxNumber => 'الرقم الضريبي';

  @override
  String get companyAddress => 'عنوان الشركة';

  @override
  String get createCompanyAccount => 'إنشاء حساب الشركة';

  @override
  String get forgotPasswordTitle => 'استعادة كلمة المرور';

  @override
  String get resetPasswordSubtitle =>
      'أدخل بريدك الإلكتروني ليصلك رمز إعادة التعيين';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get enterOtpAndNewPassword => 'أدخل رمز التحقق وكلمة المرور الجديدة';

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get updatePassword => 'تحديث كلمة المرور';

  @override
  String get pendingApprovalTitle => 'طلبك قيد المراجعة';

  @override
  String get pendingApprovalMessage =>
      'تم تسجيل حساب الشركة بنجاح. جاري مراجعة طلبك وتفعيل الحساب من قبل الإدارة، يرجى الانتظار.';

  @override
  String get logoutAndReturn => 'تسجيل الخروج والعودة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get myProfile => 'بروفايلي';

  @override
  String get wallet => 'المحفظة';

  @override
  String get points => 'النقاط';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get point => 'نقطة';

  @override
  String get personalInfo => 'المعلومات الشخصية';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get editCompanyProfile => 'تعديل ملف الشركة';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get representativeName => 'اسم الممثل المسؤول';

  @override
  String get contactPhone => 'رقم التواصل';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get confirmLogoutTitle => 'تسجيل الخروج';

  @override
  String get confirmLogoutMessage => 'هل أنت تأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get cancel => 'تراجع';

  @override
  String get exit => 'خروج';

  @override
  String get companyInformation => 'معلومات الشركة';

  @override
  String get taxNumberLabel => 'الرقم الضريبي';

  @override
  String get commercialRegLabel => 'السجل التجاري';

  @override
  String get companyAddressLabel => 'عنوان الشركة';

  @override
  String get carBrand => 'الماركة';

  @override
  String get carModel => 'الموديل';

  @override
  String get carColor => 'لون السيارة (اختياري)';

  @override
  String get carPlateNumber => 'أ ب ج 4521';

  @override
  String get bookingSetup => 'إعداد الحجز';

  @override
  String get bookingType => 'نوع الحجز';

  @override
  String get instantBooking => 'حجز فوري';

  @override
  String get scheduledBooking => 'حجز مجدول';

  @override
  String get directService => 'خدمة مباشرة';

  @override
  String get chooseDateTime => 'اختر التاريخ والوقت';

  @override
  String get vipServiceTitle => 'خدمة VIP مميزة';

  @override
  String get vipServiceSubtitle => 'أولوية وصول وفنيين متخصصين لخدمتك';

  @override
  String get serviceLocation => 'موقع تقديم الخدمة';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get manualLocation => 'إدخال يدوي';

  @override
  String get relocateCurrentPosition => 'إعادة تحديد الموقع الحالي';

  @override
  String get locatingPosition => 'جاري تحديد الموقع...';

  @override
  String get detailedAddress => 'العنوان التفصيلي';

  @override
  String get detailedAddressHint => 'مثال: الرياض - حي الملقا - شارع الملك فهد';

  @override
  String get locationServiceDisabled => 'خدمة الموقع الجغرافي غير مفعلة';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الوصول للموقع الجغرافي';

  @override
  String get locationPermissionPermanentlyDenied =>
      'تم رفض إذن الموقع دائمًا، يرجى تفعيله من الإعدادات';

  @override
  String get errorOccurred => 'حدث خطأ أثناء إحضار الموقع';

  @override
  String get selectWorkshop => 'تحديد الورشة المطلوبة';

  @override
  String get workshopSelected => 'الورشة المختارة:';

  @override
  String get chooseWorkshop => 'اضغط لاختيار الورشة المناسبة';

  @override
  String get towingDestination => 'وجهة السطحة / الونش';

  @override
  String get destinationAddress => 'عنوان الوجهة أو اسم الورشة المستهدفة';

  @override
  String get destinationAddressHint => 'مثال: الصناعية القديمة - ورشة الخليج';

  @override
  String get paymentMethod => 'وسيلة الدفع';

  @override
  String get cash => 'نقداً';

  @override
  String pointsCount(Object count) {
    return 'نقطة';
  }

  @override
  String get activePackage => 'الباقة النشطة';

  @override
  String get selectPackage => 'اختر الباقة';

  @override
  String get onlinePayment => 'دفع إلكتروني';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get notesAndRequests => 'ملاحظات وتوجيهات إضافية';

  @override
  String get notesHint => 'أكتب أي تفاصيل إضافية تود إبلاغ الفريق بها...';

  @override
  String get calculateCostAndShowTotal => 'حساب التكلفة وعرض المجموع';

  @override
  String get selectPackageTitle => 'اختر الباقة المناسبة';

  @override
  String remainingUses(Object count) {
    return 'المتبقي: $count استخدام';
  }

  @override
  String notEnoughForCars(Object count) {
    return 'لا تكفي لعدد السيارات ($count)';
  }

  @override
  String get noActivePackages => 'لا توجد باقات نشطة متاحة لهذا الحجز';

  @override
  String get bookingSummary => 'ملخص التكلفة والتأكيد';

  @override
  String get carsCount => 'عدد السيارات';

  @override
  String get totalPrice => 'المجموع الكلي';

  @override
  String get vehicleSummary => 'تفاصيل السيارات';

  @override
  String get serviceCost => 'تكلفة الخدمة';

  @override
  String get distanceCost => 'تكلفة المسافة';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get discount => 'الخصم';

  @override
  String get invoiceTotal => 'إجمالي الفاتورة';

  @override
  String get totalAmount => 'الإجمالي الكلي';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get currencySyrian => 'ل.س';

  @override
  String get bookingSuccess => 'تم إنشاء الحجز بنجاح!';

  @override
  String get myCars => 'مركباتي';

  @override
  String get addCar => 'إضافة سيارة';

  @override
  String get addNewCar => 'إضافة سيارة جديدة';

  @override
  String get editCar => 'تعديل بيانات السيارة';

  @override
  String get carAddedSuccess => 'تم إضافة السيارة بنجاح';

  @override
  String get carUpdatedSuccess => 'تم تعديل بيانات السيارة بنجاح';

  @override
  String get carDeletedSuccess => 'تم حذف السيارة بنجاح';

  @override
  String get deleteCar => 'حذف السيارة';

  @override
  String get confirmDeleteCar =>
      'هل أنت تأكد من أنك تريد حذف هذه السيارة من قائمة مركباتك؟';

  @override
  String get noCarsAdded => 'لا يوجد لديك سيارات مضافة';

  @override
  String get noCarsSubtitle =>
      'قم بإضافة مركبتك الأولى الآن لتتمكن من حجز الخدمات والصيانة بسهولة';

  @override
  String get addCarImageHint => 'اضغط لإضافة صورة للسيارة (اختياري)';

  @override
  String get carType => 'نوع السيارة';

  @override
  String get carModelHint => 'مثال: كامري / سوناتا';

  @override
  String get plateNumber => 'رقم اللوحة';

  @override
  String get plateNumberHint => 'مثال: أ ب ج 1234';

  @override
  String get manufactureYear => 'سنة الصنع';

  @override
  String get manufactureYearHint => 'مثال: 2022';

  @override
  String get currentMileage => 'عداد الكيلومترات (اختياري)';

  @override
  String get currentMileageHint => 'مثال: 55000';

  @override
  String get cylindersCount => 'عدد السلندرات (اختياري)';

  @override
  String get cylindersCountHint => 'مثال: 4 / 6 / 8';

  @override
  String get carColorHint => 'مثال: أبيض / أسود';

  @override
  String get fuelType => 'نوع الوقود';

  @override
  String get fuelPetrol => 'بنزين';

  @override
  String get fuelDiesel => 'ديزل';

  @override
  String get fuelHybrid => 'هايبرايد';

  @override
  String get fuelElectric => 'كهرباء';

  @override
  String get ourBranches => 'فروعنا';

  @override
  String get branchDetails => 'تفاصيل الفرع';

  @override
  String get searchBranchHint => 'ابحث عن فرع، مدينة، أو عنوان...';

  @override
  String distanceKm(Object distance) {
    return '$distance كم';
  }

  @override
  String get workingHours => 'ساعات العمل';

  @override
  String get phoneCall => 'اتصال';

  @override
  String get locationOnMap => 'الموقع';

  @override
  String get openLocationOnMap => 'فتح في خرائط جوجل';

  @override
  String get copyLocationLink => 'نسخ رابط الموقع';

  @override
  String get managerName => 'اسم المدير';

  @override
  String get noBranchesFound => 'لم نجد فروعاً تطابق بحثك';

  @override
  String get tryAnotherSearch => 'جرّب اسماً أو مدينة أخرى';

  @override
  String get addingMoreBranchesSoon => 'سنضيف فروعاً جديدة قريباً';

  @override
  String copiedLabel(Object label) {
    return 'تم نسخ $label';
  }

  @override
  String get unableToCall => 'تعذر فتح تطبيق الاتصال';

  @override
  String get unableToOpenMap => 'تعذر فتح الخريطة';

  @override
  String get errorLoadingBranches => 'حدث خطأ أثناء تحميل الفروع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get wash => 'غسيل';

  @override
  String get maintenance => 'صيانة';

  @override
  String get oil => 'زيت';

  @override
  String get welcome => 'أهلاً بك 👋';

  @override
  String get chooseCarService => 'اختر خدمة سيارتك';

  @override
  String get specialDiscount => 'خصم خاص 20%';

  @override
  String get fullCarCare => 'عناية كاملة بسيارتك';

  @override
  String get bookWashPackageNow => 'احجز باقة الغسيل والتلميع الشامل الآن';

  @override
  String get noServicesAvailable => 'لا توجد خدمات متاحة حالياً لهذا القسم';

  @override
  String get vip => 'VIP ⭐';

  @override
  String get defaultServiceDescription =>
      'خدمة عالية الجودة ومضمونة مع أفضل الفنيين.';

  @override
  String minutesFormat(Object minutes) {
    return '$minutes دقيقة';
  }

  @override
  String currencyJod(Object price) {
    return '$price د.أ';
  }

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get mainCategories => 'الأقسام الرئيسية';

  @override
  String get showAll => 'عرض الكل';

  @override
  String get availableServices => 'الخدمات المتاحة';

  @override
  String get fleet => 'الأسطول';

  @override
  String get home => 'الرئيسية';

  @override
  String get companyOrders => 'طلبات الشركة';

  @override
  String get myAccount => 'حسابي';

  @override
  String get garage => 'الكراج';

  @override
  String get packages => 'الباقات';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get now => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count دقيقة';
  }

  @override
  String get twoMinutesAgo => 'منذ دقيقتين';

  @override
  String get oneMinuteAgo => 'منذ دقيقة';

  @override
  String hoursAgo(Object count) {
    return 'منذ $count ساعات';
  }

  @override
  String get twoHoursAgo => 'منذ ساعتين';

  @override
  String get oneHourAgo => 'منذ ساعة';

  @override
  String daysAgo(Object count) {
    return 'منذ $count أيام';
  }

  @override
  String get twoDaysAgo => 'منذ يومين';

  @override
  String get oneDayAgo => 'منذ يوم';

  @override
  String get failedToFetchNotifications => 'تعذر جلب الإشعارات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String unreadNotificationsCount(Object count) {
    return 'لديك $count إشعار غير مقروء';
  }

  @override
  String get noUnreadNotifications => 'لا توجد إشعارات غير مقروءة';

  @override
  String get markAllAsRead => 'تعليم الكل';

  @override
  String get all => 'الكل';

  @override
  String get unread => 'غير المقروءة';

  @override
  String get noNotificationsYet => 'لا توجد إشعارات بعد';

  @override
  String get allCaughtUp => 'اطّلعت على كل شيء 👌';

  @override
  String get notificationUpdatesHint => 'ستصلك هنا تحديثات طلباتك ومحفظتك';

  @override
  String get package => 'باقة';

  @override
  String get currencySyrianPound => 'ل.س';

  @override
  String get confirm => 'تأكيد';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get orderNumber => 'طلب #';

  @override
  String get service => 'الخدمة';

  @override
  String get totalPaid => 'الإجمالي المدفوع';

  @override
  String get appointment => 'الموعد';

  @override
  String get car => 'السيارة';

  @override
  String get workshop => 'الورشة';

  @override
  String get status => 'الحالة';

  @override
  String get notes => 'ملاحظات';

  @override
  String get cancellationAvailableUntil => 'الإلغاء متاح حتى';

  @override
  String get rebook => 'إعادة الطلب';

  @override
  String get rateService => 'قيّم الخدمة';

  @override
  String get cancelling => 'جارٍ الإلغاء';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get newBookingCreated => 'تم إنشاء الحجز الجديد';

  @override
  String get bookingCancelledSuccessfully => 'تم إلغاء الحجز بنجاح';

  @override
  String get orderHistory => 'سجل الطلبات';

  @override
  String get orderHistorySubTitle => 'جميع طلباتك السابقة والحالية';

  @override
  String get noOrdersYet => 'لا توجد طلبات حالياً';

  @override
  String get rebookTitle => 'إعادة الحجز';

  @override
  String get rebookDescription =>
      'تُنشأ نسخة جديدة من الطلب — الطلب الأصلي يبقى كما هو';

  @override
  String get selectAppointmentFirst => 'اختر موعد الحجز أولاً';

  @override
  String get futureAppointmentError => 'يجب اختيار موعد في المستقبل';

  @override
  String get selectPackagePrompt => 'اختر الباقة التي تريد استخدامها';

  @override
  String get failedToLoadRebookData => 'تعذر تحميل بيانات إعادة الحجز';

  @override
  String get bookingTime => 'موعد الحجز';

  @override
  String get scheduled => 'مجدول';

  @override
  String get immediate => 'فوري';

  @override
  String get immediateHint => 'سيبدأ التنفيذ خلال ساعة من تأكيد الحجز';

  @override
  String get selectDateAndTime => 'اختر التاريخ والوقت';

  @override
  String get noValidPackagesForBooking =>
      'لا توجد باقات صالحة لهذا الحجز، اختر طريقة دفع أخرى';

  @override
  String get additionalDetails => 'تفاصيل إضافية';

  @override
  String get vipService => 'خدمة VIP';

  @override
  String get vipServiceHint => 'أولوية في التنفيذ مقابل رسوم إضافية';

  @override
  String get notesForTechnicianOptional => 'ملاحظات للفني (اختياري)';

  @override
  String get quoteExpiredError => 'انتهت صلاحية التسعيرة، أعد التسعير للمتابعة';

  @override
  String get confirming => 'جارٍ التأكيد';

  @override
  String get recalculatePrice => 'إعادة التسعير';

  @override
  String get calculatingPrice => 'جارٍ حساب السعر';

  @override
  String get calculatePrice => 'احسب السعر';

  @override
  String get originalService => 'الخدمة الأصلية';

  @override
  String get originalServiceUnchangeable =>
      'الخدمة غير قابلة للتغيير في إعادة الحجز';

  @override
  String get newQuote => 'التسعيرة الجديدة';

  @override
  String get quoteDynamicPriceNote =>
      'السعر محسوب بالأسعار الحالية وقد يختلف عن الطلب السابق';

  @override
  String get serviceValue => 'قيمة الخدمة';

  @override
  String get remainingCash => 'المتبقي نقداً';

  @override
  String get quoteExpired => 'انتهت صلاحية التسعيرة';

  @override
  String get validDurationMinutes => 'صالحة';

  @override
  String get cancelReasonChangedMind => 'غيّرت رأيي';

  @override
  String get cancelReasonTimeUnsuitable => 'الموعد لم يعد مناسباً';

  @override
  String get cancelReasonAccidentalBooking => 'حجزت عن طريق الخطأ';

  @override
  String get cancelReasonFoundOtherService => 'وجدت خدمة أخرى';

  @override
  String get whatHappensOnCancel => 'ماذا يحدث عند الإلغاء؟';

  @override
  String get cancelConsequenceRefund => 'يُعاد المبلغ المدفوع حسب طريقة الدفع';

  @override
  String get cancelConsequencePoints =>
      'تُسترجع نقاط الولاء التي رُبحت من الطلب';

  @override
  String get cancelConsequenceMaterials => 'تُعاد المواد المحجوزة إلى المخزون';

  @override
  String get cancelConsequenceRecord => 'يبقى الطلب في السجل بحالة ملغي';

  @override
  String get cancelReasonRequiredTitle => 'سبب الإلغاء (مطلوب)';

  @override
  String get cancelReasonPlaceholder => 'اكتب سبب الإلغاء هنا';

  @override
  String get cancelReasonRequiredError => 'سبب الإلغاء مطلوب';

  @override
  String get maxReasonLengthExceeded => 'الحد الأقصى للملاحظات تم تجاوزه';

  @override
  String get confirmCancellation => 'تأكيد الإلغاء';

  @override
  String get maintenanceService => 'خدمة صيانة';

  @override
  String get orderStages => 'مراحل الطلب';

  @override
  String get runningSince => 'جارٍ منذ';

  @override
  String get executionDuration => 'مدة التنفيذ';

  @override
  String get startDelay => 'تأخر البدء';

  @override
  String get startedEarly => 'بدأ مبكراً';

  @override
  String get currentStatus => 'الحالة الحالية';

  @override
  String get notCompletedYet => 'لم تتم بعد';

  @override
  String get timeNotAvailable => 'الوقت غير متاح';

  @override
  String get reason => 'السبب';

  @override
  String get activeSubscription => 'اشتراك نشط';

  @override
  String get currentPackage => 'باقتك الحالية';

  @override
  String get remainingServices => 'الخدمات المتبقية';

  @override
  String get remaining => 'متبقّي';

  @override
  String get expiresIn => 'ينتهي خلال';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get today => 'اليوم';

  @override
  String get daysCount => 'يوم';

  @override
  String get carCarePlusPackageSubtitle => 'باقة خدمات من كار كير بلس';

  @override
  String get servicesCount => 'خدمات';

  @override
  String get validityDays => 'يوم';

  @override
  String get price => 'السعر';

  @override
  String get activated => 'مفعّلة';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get subscribe => 'اشترك';

  @override
  String get discountPercentage => 'خصم';

  @override
  String get packageValidity => 'الصلاحية';

  @override
  String get aboutPackage => 'عن الباقة';

  @override
  String get noExtraDescriptionForPackage => 'لا يوجد وصف إضافي لهذه الباقة.';

  @override
  String get alreadySubscribedToPackage => 'أنت مشترك في هذه الباقة';

  @override
  String get subscribeNow => 'اشترك الآن';

  @override
  String get currentlyNotAvailable => 'غير متاح حالياً';

  @override
  String get confirmSubscription => 'تأكيد الاشتراك';

  @override
  String get confirmSubscriptionDialogBody =>
      'سيتم الاشتراك في الباقة وخصم المبلغ من محفظتك.';

  @override
  String get cannotSubscribeAnotherPackageWarning =>
      'لا يمكنك الاشتراك بباقة أخرى قبل انتهاء هذه الباقة.';

  @override
  String get failedToFetchPackages => 'تعذر جلب الباقات';

  @override
  String get availablePackages => 'الباقات المتاحة';

  @override
  String get canSubscribeAfterCurrentEndsHint =>
      'يمكنك الاشتراك بباقة جديدة بعد انتهاء اشتراكك الحالي';

  @override
  String get choosePackageSuitingYou => 'اختر الباقة التي تناسب استخدامك';

  @override
  String get youHaveActiveSubscription => 'لديك اشتراك نشط';

  @override
  String get saveMoreWithPackagesSubtitle =>
      'وفّر أكثر مع باقات الصيانة والغسيل';

  @override
  String get noActiveSubscription => 'لا يوجد اشتراك نشط';

  @override
  String get choosePackageToStart => 'اختر باقة من الأسفل للبدء';

  @override
  String get noPackagesAvailableCurrently => 'لا توجد باقات متاحة حالياً';

  @override
  String get pleaseRateServiceFirst => 'يرجى تقييم الخدمة أولاً';

  @override
  String get thankYouRatingSubmitted => 'شكراً لك! تم إرسال تقييمك بنجاح';

  @override
  String get yourOpinionMatters => 'رأيك يهمّنا';

  @override
  String get rateYourExperienceHint =>
      'قيّم تجربتك مع هذا الطلب لمساعدتنا على التحسّن';

  @override
  String get mandatory => 'إلزامي';

  @override
  String get employee => 'الموظف';

  @override
  String get optional => 'اختياري';

  @override
  String get additionalComments => 'ملاحظات إضافية';

  @override
  String get writeYourNotesHere => 'اكتب ملاحظاتك هنا...';

  @override
  String get sendRating => 'إرسال التقييم';

  @override
  String get totalCost => 'التكلفة الإجمالية';

  @override
  String get bookAppointment => 'حجز الموعد';

  @override
  String get expectedDuration => 'المدة المتوقعة: ';

  @override
  String get description => 'الوصف';

  @override
  String get preparingServiceDetails => 'جاري تحضير تفاصيل الخدمة...';

  @override
  String get selectCar => 'اختيار السيارة';

  @override
  String get subServicesAndAddons => 'الخدمات الفرعية والإضافات';

  @override
  String get addedMaterialsAndParts => 'المواد والقطع المضافة';

  @override
  String get pleaseSelectCarFirst => 'يرجى تحديد السيارة أولاً';

  @override
  String get availableBalance => 'الرصيد المتاح';

  @override
  String get currencySar => 'ر.س';

  @override
  String get currencySyp => 'ل.س';

  @override
  String get chargeBalance => 'شحن الرصيد';

  @override
  String get balance => 'الرصيد ';

  @override
  String get paymentDetails => 'تفاصيل الدفع';

  @override
  String get paymentReceipt => 'إيصال عملية دفع';

  @override
  String get transactionCode => 'رمز العملية';

  @override
  String get transactionType => 'نوع العملية';

  @override
  String get paymentStatus => 'حالة الدفع';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get completed => 'مكتملة';

  @override
  String get pointsUsed => 'النقاط المستفاد منها';

  @override
  String get walletAndPayments => 'المحفظة والمدفوعات';

  @override
  String get walletTopupViaSupportHint =>
      'شحن الرصيد يتم عبر الدعم حالياً، ويصلك الرصيد فور إضافته';

  @override
  String get transactionHistory => 'سجل الحركات';

  @override
  String get transactionsCount => 'حركة';

  @override
  String get paymentsAndBalanceAdditions => 'المدفوعات وعمليات إضافة الرصيد';

  @override
  String get noTransactionsYet => 'لا توجد حركات بعد';

  @override
  String get emptyTransactionsSubtitle =>
      'ستظهر هنا مدفوعات حجوزاتك وأي رصيد يُضاف إلى محفظتك';

  @override
  String get chooseMaintenanceWorkshop => 'اختر ورشة الصيانة';

  @override
  String get nearbyActiveWorkshopsSubtitle =>
      'الورش النشطة القريبة من موقعك، مرتّبة بالأقرب';

  @override
  String get noActiveWorkshopsNearby => 'لا توجد ورش نشطة قريبة من موقعك';

  @override
  String get km => 'كم';

  @override
  String get language => 'اللغة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get aiAssistant => 'المساعد الذكي';

  @override
  String get aiChatGreetingTitle =>
      'مرحباً 👋 أنا مساعدك الذكي لتشخيص أعطال سيارتك.';

  @override
  String get aiChatGreetingBody =>
      'صف لي المشكلة التي تواجهها، ثم سأسألك بضعة أسئلة قصيرة قبل أن أعطيك التشخيص.';

  @override
  String get aiArabicContentNote =>
      'أسئلة المساعد وتشخيصه تصل بالعربية دائماً.';

  @override
  String get aiChatDescribeProblemHint => 'صف مشكلة سيارتك...';

  @override
  String get aiChatAnswerHint => 'اكتب إجابتك...';

  @override
  String get aiChatFinishedHint => 'انتهت المحادثة — ابدأ محادثة جديدة';

  @override
  String get aiChatErrorHint => 'أعد المحاولة أو ابدأ محادثة جديدة';

  @override
  String get aiChatAnalyzing => 'جارٍ تحليل المشكلة، قد يستغرق ذلك دقيقة...';

  @override
  String get aiChatPreparing => 'جارٍ التحضير...';

  @override
  String get aiChatNewConversation => 'محادثة جديدة';

  @override
  String get aiChatStartNewConversation => 'بدء محادثة جديدة';

  @override
  String get aiDiagnosisResult => 'نتيجة التشخيص';

  @override
  String get aiPossibleCauses => 'الأسباب المحتملة';

  @override
  String get aiRecommendedService => 'الخدمة المقترحة';

  @override
  String get aiNoMatchingService =>
      'لا توجد خدمة مقترحة مطابقة — يرجى التواصل مع الورشة';

  @override
  String get aiGeneratedDisclaimer =>
      'إجابة مولّدة بالذكاء الاصطناعي وقد تحتوي أخطاء — الفحص في الورشة يبقى المرجع';

  @override
  String get aiSeverityLow => 'خطورة منخفضة';

  @override
  String get aiSeverityMedium => 'خطورة متوسطة';

  @override
  String get aiSeverityHigh => 'خطورة عالية';

  @override
  String get aiAddServiceToOrder => 'إضافة الخدمة إلى الطلب';

  @override
  String get aiServiceAddedToOrder => 'تمت إضافة الخدمة إلى الطلب';

  @override
  String get aiApplyServiceConfirmTitle => 'إضافة الخدمة إلى الطلب';

  @override
  String aiApplyServiceConfirmBody(Object service) {
    return 'سيتم استبدال خدمة الطلب الحالية بخدمة \"$service\" وإعادة احتساب السعر الإجمالي للطلب. هل تريد المتابعة؟';
  }

  @override
  String get aiServiceAppliedSuccess => 'تمت إضافة الخدمة إلى الطلب بنجاح';

  @override
  String get aiDiagnosisUnavailable =>
      'التشخيص غير متاح حالياً، يرجى المحاولة لاحقاً';

  @override
  String get aiApplyServiceFailed => 'تعذّر إضافة الخدمة إلى الطلب';

  @override
  String get aiConversationLoopError =>
      'تعذّر إكمال المحادثة، يرجى بدء محادثة جديدة';

  @override
  String get aiUnexpectedError => 'حدث خطأ غير متوقع';
}
