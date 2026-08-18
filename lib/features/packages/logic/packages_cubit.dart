import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:car_care_plus/features/packages/data/models/user_package_model.dart';
import 'package:car_care_plus/features/packages/data/repos/packages_repo.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final PackagesRepo _packagesRepo;

  PackagesCubit(this._packagesRepo) : super(const PackagesState());

  void _safeEmit(PackagesState state) {
    if (!isClosed) emit(state);
  }

  /// جلب الباقات المتاحة واشتراك المستخدم النشط معاً
  Future<void> emitFetchPackagesData() async {
    _safeEmit(state.copyWith(status: PackagesStatus.loading, clearMessages: true));
    try {
      final userPackagesFuture = _packagesRepo.getUserPackages();
      final packagesFuture = _packagesRepo.getPackages();
      // الرصيد يقرّر إمكانية الشراء: لا توجد نقطة نهاية لشحن المحفظة،
      // فالمستخدم بلا رصيد كافٍ لا يستطيع الشراء أصلاً
      final balanceFuture = _packagesRepo.getMyWalletBalance();

      final userPackages = await userPackagesFuture;
      final allPackages = await packagesFuture;

      double? balance;
      try {
        balance = await balanceFuture;
      } catch (_) {
        // تعذّر قراءة الرصيد لا يمنع عرض الباقات
      }

      final active = _findActivePackage(userPackages);

      _safeEmit(
        state.copyWith(
          status: PackagesStatus.success,
          // الباك اند لا يصفّي الخطط غير المفعّلة، فنستبعدها هنا
          availablePackages:
              allPackages.where((package) => package.isActive).toList(),
          activeUserPackage: active,
          walletBalance: balance,
          // بدون هذا يبقى اشتراك قديم معروضاً بعد انتهائه
          clearActivePackage: active == null,
          clearMessages: true,
        ),
      );
    } catch (error) {
      _safeEmit(
        state.copyWith(
          status: PackagesStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// تفاصيل باقة لعرضها في الورقة السفلية
  Future<void> emitGetPackageDetails(int packageId) async {
    _safeEmit(
      state.copyWith(
        isLoadingDetails: true,
        clearSelectedPackage: true,
        clearMessages: true,
      ),
    );
    try {
      final package = await _packagesRepo.getPackageDetails(packageId);
      _safeEmit(
        state.copyWith(selectedPackage: package, isLoadingDetails: false),
      );
    } catch (error) {
      _safeEmit(
        state.copyWith(
          isLoadingDetails: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// الاشتراك في باقة.
  ///
  /// يُرفض الطلب هنا قبل الوصول للسيرفر إذا كان لدى المستخدم اشتراك نشط —
  /// لا يُسمح بأكثر من باقة فعّالة في الوقت نفسه.
  Future<void> emitSubscribeToPackage({required int packageId}) async {
    if (state.isSubscribing) return;

    if (state.hasActiveSubscription) {
      final current = state.activeUserPackage?.packageDetails?.name;
      _safeEmit(
        state.copyWith(
          errorMessage: current == null
              ? 'لديك باقة نشطة بالفعل، لا يمكن الاشتراك بأخرى قبل انتهائها'
              : 'لديك اشتراك نشط في «$current»، لا يمكن الاشتراك بأخرى قبل انتهائه',
        ),
      );
      return;
    }

    _safeEmit(
      state.copyWith(subscribingPackageId: packageId, clearMessages: true),
    );
    try {
      await _packagesRepo.subscribeToPackage(packageId);

      // نعيد الجلب لنقرأ الاشتراك الجديد من السيرفر بدل افتراض شكله،
      // والرصيد تغيّر لأن الشراء يخصم من المحفظة
      final userPackages = await _packagesRepo.getUserPackages();
      final active = _findActivePackage(userPackages);

      double? balance;
      try {
        balance = await _packagesRepo.getMyWalletBalance();
      } catch (_) {
        // الرصيد ليس حرجاً بعد نجاح الاشتراك
      }

      _safeEmit(
        state.copyWith(
          activeUserPackage: active,
          clearActivePackage: active == null,
          walletBalance: balance,
          clearSubscribing: true,
          successMessage: 'تم الاشتراك في الباقة بنجاح',
        ),
      );
    } catch (error) {
      _safeEmit(
        state.copyWith(
          clearSubscribing: true,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// تُستدعى بعد عرض الرسالة حتى لا تتكرر عند إعادة البناء
  void clearMessages() => _safeEmit(state.copyWith(clearMessages: true));

  /// الاشتراك النشط: الحالة `active` ولم ينتهِ تاريخه بعد.
  ///
  /// لا شيء في الباك اند يحوّل الحالة إلى `expired` عند مرور التاريخ،
  /// لذلك نحسب الانتهاء من `end_date` لا من `status`.
  UserPackageModel? _findActivePackage(List<UserPackageModel> userPackages) {
    for (final package in userPackages) {
      if (package.status.trim().toLowerCase() != 'active') continue;
      if (package.isExpired) continue;
      return package;
    }
    return null;
  }
}

/// أدوات عرض على اشتراك المستخدم.
///
/// ⚠️ `start_date` و`end_date` تواريخ فقط بصيغة `YYYY-MM-DD` بلا وقت ولا
/// منطقة زمنية، لذلك نقارنها كتواريخ لا كلحظات — وإلا اعتُبر الاشتراك
/// منتهياً منذ منتصف ليل يوم انتهائه.
extension UserPackageDisplay on UserPackageModel {
  DateTime? get endsAt =>
      endDate == null ? null : DateTime.tryParse(endDate!);

  DateTime? get startsAt =>
      startDate == null ? null : DateTime.tryParse(startDate!);

  /// انتهى الاشتراك إذا مضى يوم الانتهاء بالكامل
  bool get isExpired {
    final end = endsAt;
    if (end == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDay = DateTime(end.year, end.month, end.day);
    return endDay.isBefore(today);
  }

  /// الأيام المتبقية على انتهاء الاشتراك
  int? get daysRemaining {
    final end = endsAt;
    if (end == null) return null;
    final days = end.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  /// نسبة الاستخدام المتبقية، للاستخدام في شريط التقدّم
  double? usageRatio(PackageModel? package) {
    final total = package?.servicesCount ?? 0;
    if (total <= 0) return null;
    final ratio = remainingCount / total;
    return ratio.clamp(0.0, 1.0);
  }
}
