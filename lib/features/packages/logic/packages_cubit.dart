import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/features/packages/data/repos/packages_repo.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';
import 'package:car_care_plus/features/packages/data/models/user_package_model.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final PackagesRepo _packagesRepo;

  PackagesCubit(this._packagesRepo) : super(PackagesInitial());

  /// جلب الباقات المتاحة + الباقة المفعلة للمستخدم
  void emitFetchPackagesData() async {
    emit(PackagesLoading());
    try {
      // تنفيذ الطلبين بشكل بالتوازي (Parallel Requests)
      final results = await Future.wait([
        _packagesRepo.getUserPackages(),
        _packagesRepo.getPackages(),
      ]);

      final userPackages = results[0] as List<UserPackageModel>;
      final availablePackages = results[1] as List<PackageModel>;

      // البحث عن الباقة المفعلة حالياً (active)
      UserPackageModel? activePackage;
      try {
        activePackage = userPackages.firstWhere(
          (pkg) => pkg.status.toLowerCase() == 'active',
        );
      } catch (_) {
        activePackage = null; // لا يوجد اشتراك نشط
      }

      emit(PackagesLoadedSuccess(
        activeUserPackage: activePackage,
        availablePackages: availablePackages,
      ));
    } catch (error) {
      emit(PackagesError(error.toString()));
    }
  }


void emitSubscribeToPackage({
  required int packageId,
  required double packagePrice,
}) async {
  emit(SubscribePackageLoading());
  try {
    // 1️⃣ التحقق من رصيد المحفظة الحالي
    final balance = await _packagesRepo.getMyWalletBalance();

    if (balance < packagePrice) {
      emit(PackagesError(
        'رصيد المحفظة غير كافٍ للاشتراك. الرصيد الحالي: $balance ل.س، وسعر الباقة: $packagePrice ل.س',
      ));
      return;
    }

    // 2️⃣ خصم قيمة الباقة من المحفظة
    await _packagesRepo.adjustWalletBalance(
      amount: -packagePrice,
      notes: 'خصم اشتراك باقة رقم $packageId',
    );

    // 3️⃣ تفعيل الاشتراك بالباقة بعد نجاح الخصم
    final userPackage = await _packagesRepo.subscribeToPackage(packageId);
    emit(SubscribePackageSuccess(userPackage));
  } catch (error) {
    emit(PackagesError(error.toString()));
  }
}
}