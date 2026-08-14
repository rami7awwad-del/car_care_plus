import 'package:car_care_plus/features/packages/data/models/package_service_model.dart';

abstract class PackagesState {}

class PackagesInitial extends PackagesState {}

/// حالة التحميل الخاصة بجلب الباقات
class PackagesLoading extends PackagesState {}

/// حالة نجاح جلب باقات الخدمات
class PackageServicesSuccess extends PackagesState {
  final List<PackageServiceModel> packageServices;
  PackageServicesSuccess(this.packageServices);
}

/// حالة الفشل العامة
class PackagesError extends PackagesState {
  final String error;
  PackagesError(this.error);
}

// -------------------------------------------------------------
// 👈 الحالات الخاصة بطلب الاشتراك في الباقة:
// -------------------------------------------------------------

/// حالة جاري إرسال طلب الاشتراك
class SubscribePackageLoading extends PackagesState {}

/// حالة نجاح الاشتراك في الباقة
class SubscribePackageSuccess extends PackagesState {
  final dynamic userPackage;
  SubscribePackageSuccess(this.userPackage);
}