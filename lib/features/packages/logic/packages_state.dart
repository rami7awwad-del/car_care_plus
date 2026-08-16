import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:car_care_plus/features/packages/data/models/user_package_model.dart';

abstract class PackagesState {}

class PackagesInitial extends PackagesState {}
class PackagesLoading extends PackagesState {}

class PackagesLoadedSuccess extends PackagesState {
  final UserPackageModel? activeUserPackage; // الباقة المفعلة للمستخدم (قد تكون null)
  final List<PackageModel> availablePackages; // جميع الباقات المتوفرة

  PackagesLoadedSuccess({
    required this.activeUserPackage,
    required this.availablePackages,
  });
}

class PackageDetailsLoading extends PackagesState {}
class PackageDetailsSuccess extends PackagesState {
  final PackageModel packageDetails;
  PackageDetailsSuccess(this.packageDetails);
}

class PackagesError extends PackagesState {
  final String error;
  PackagesError(this.error);
}

class SubscribePackageLoading extends PackagesState {}
class SubscribePackageSuccess extends PackagesState {
  final dynamic userPackage;
  SubscribePackageSuccess(this.userPackage);
}