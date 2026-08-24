import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:car_care_plus/features/packages/data/models/user_package_model.dart';

enum PackagesStatus { initial, loading, success, error }

/// حالة واحدة تحتفظ بالباقات والاشتراك النشط معاً.
///
/// كانت الحالات السابقة منفصلة، فكان فتح تفاصيل باقة أو بدء اشتراك يمسح
/// الاشتراك النشط من الحالة — وهو ما يجعل منع الاشتراك المزدوج مستحيلاً،
/// ويجعل شاشة الحجز تظن أن المستخدم بلا باقة أثناء تلك اللحظات.
class PackagesState {
  final PackagesStatus status;

  /// كل الباقات كما وصلت من السيرفر
  final List<PackageModel> availablePackages;

  /// اشتراك المستخدم النشط، وهو المصدر الوحيد لمنع اشتراك ثانٍ
  final UserPackageModel? activeUserPackage;

  /// تفاصيل الباقة المعروضة في الورقة السفلية
  final PackageModel? selectedPackage;
  final bool isLoadingDetails;

  /// معرّف الباقة الجاري الاشتراك بها، لتعطيل زرها وحده
  final int? subscribingPackageId;

  /// رصيد المحفظة — الشراء يخصم من المحفظة ولا توجد نقطة نهاية لشحنها،
  /// لذلك نتحقق من كفايته قبل عرض زر الشراء بدل ترك السيرفر يرفض بـ 422
  final double? walletBalance;

  final String? errorMessage;
  final String? successMessage;

  const PackagesState({
    this.status = PackagesStatus.initial,
    this.availablePackages = const [],
    this.activeUserPackage,
    this.selectedPackage,
    this.isLoadingDetails = false,
    this.subscribingPackageId,
    this.walletBalance,
    this.errorMessage,
    this.successMessage,
  });

  /// هل لدى المستخدم اشتراك فعّال؟ لا يُسمح بأكثر من واحد في الوقت نفسه.
  bool get hasActiveSubscription => activeUserPackage != null;

  bool get isSubscribing => subscribingPackageId != null;

  /// هل هذه الباقة تحديداً هي اشتراك المستخدم الحالي؟
  bool isCurrentSubscription(int packageId) =>
      activeUserPackage?.packageId == packageId;

  /// سعر الباقة كرقم — يصل من الباك اند كنص
  double priceOf(PackageModel package) =>
      double.tryParse(package.price) ?? 0;

  /// هل يكفي رصيد المحفظة لشراء هذه الباقة؟
  /// نعتبره كافياً إذا تعذّر قراءة الرصيد، فلا نمنع الشراء بلا سبب.
  bool canAfford(PackageModel package) {
    final balance = walletBalance;
    if (balance == null) return true;
    return balance >= priceOf(package);
  }

  /// المبلغ الناقص لإتمام الشراء
  double shortfallFor(PackageModel package) {
    final balance = walletBalance;
    if (balance == null) return 0;
    final missing = priceOf(package) - balance;
    return missing > 0 ? missing : 0;
  }

  /// يُسمح بالاشتراك فقط إذا كانت الباقة متاحة، ولا يوجد اشتراك نشط،
  /// والرصيد يكفي
  bool canSubscribeTo(PackageModel package) =>
      package.isActive && !hasActiveSubscription && canAfford(package);

  /// سبب تعذّر الاشتراك، لعرضه بدل زر معطّل بلا تفسير
  String? blockedReasonFor(PackageModel package) {
    if (isCurrentSubscription(package.id)) return 'أنت مشترك في هذه الباقة';
    if (hasActiveSubscription) {
      final current = activeUserPackage?.packageDetails?.name;
      return current == null
          ? 'لديك باقة نشطة، لا يمكن الاشتراك بأخرى قبل انتهائها'
          : 'لديك اشتراك نشط في «$current»، لا يمكن الاشتراك بأخرى قبل انتهائه';
    }
    if (!package.isActive) return 'هذه الباقة غير متاحة حالياً';
    if (!canAfford(package)) {
      // لا توجد نقطة نهاية لشحن المحفظة، فنوضّح الطريق البديل
      return 'رصيد محفظتك لا يكفي، ينقصك ${shortfallFor(package).toStringAsFixed(0)} ل.س';
    }
    return null;
  }

  PackagesState copyWith({
    PackagesStatus? status,
    List<PackageModel>? availablePackages,
    UserPackageModel? activeUserPackage,
    PackageModel? selectedPackage,
    bool? isLoadingDetails,
    int? subscribingPackageId,
    double? walletBalance,
    String? errorMessage,
    String? successMessage,
    bool clearActivePackage = false,
    bool clearSelectedPackage = false,
    bool clearSubscribing = false,
    bool clearMessages = false,
  }) {
    return PackagesState(
      status: status ?? this.status,
      availablePackages: availablePackages ?? this.availablePackages,
      activeUserPackage: clearActivePackage
          ? null
          : (activeUserPackage ?? this.activeUserPackage),
      selectedPackage: clearSelectedPackage
          ? null
          : (selectedPackage ?? this.selectedPackage),
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      subscribingPackageId: clearSubscribing
          ? null
          : (subscribingPackageId ?? this.subscribingPackageId),
      walletBalance: walletBalance ?? this.walletBalance,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}
