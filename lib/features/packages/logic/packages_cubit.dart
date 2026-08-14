import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/features/packages/data/repos/packages_repo.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final PackagesRepo _packagesRepo;

  PackagesCubit(this._packagesRepo) : super(PackagesInitial());

  /// 1️⃣ جلب باقات الخدمات المتاحة للكتالوج
  void emitGetPackageServices() async {
    emit(PackagesLoading());
    try {
      final packageServices = await _packagesRepo.getPackageServices();
      emit(PackageServicesSuccess(packageServices));
    } catch (error) {
      emit(PackagesError(error.toString()));
    }
  }

  /// 2️⃣ الاشتراك في باقة محددة
  void emitSubscribeToPackage(int packageId) async {
    emit(SubscribePackageLoading());
    try {
      final userPackage = await _packagesRepo.subscribeToPackage(packageId);
      emit(SubscribePackageSuccess(userPackage));
    } catch (error) {
      emit(PackagesError(error.toString()));
    }
  }
}