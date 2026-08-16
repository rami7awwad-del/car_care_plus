import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:car_care_plus/features/packages/data/models/user_package_model.dart';

class PackagesRepo {
  final ApiService _apiService;

  PackagesRepo(this._apiService);

  /// 1️⃣ جلب الباقات المتاحة للطلب (Catalog)
  Future<List<PackageModel>> getPackages() async {
    try {
      final response = await _apiService.get(endpoint: 'packages');
      final List data = response.data['data'] as List;
      return data.map((item) => PackageModel.fromJson(item)).toList();
    } catch (error) {
      rethrow;
    }
  }

  /// 2️⃣ جلب الباقة/الباقات المشترك فيها المستخدم حالياً
  Future<List<UserPackageModel>> getUserPackages() async {
    try {
      final response = await _apiService.get(endpoint: 'user-packages');
      final List data = response.data['data'] as List;
      return data.map((item) => UserPackageModel.fromJson(item)).toList();
    } catch (error) {
      rethrow;
    }
  }

  /// 3️⃣ جلب تفاصيل باقة معينة مع خدماتها المشمولة
  Future<PackageModel> getPackageDetails(int packageId) async {
    try {
      final response = await _apiService.get(endpoint: 'packages/$packageId');
      return PackageModel.fromJson(response.data['data']);
    } catch (error) {
      rethrow;
    }
  }

  /// 4️⃣ الاشتراك في باقة محددة
  Future<dynamic> subscribeToPackage(int packageId) async {
    try {
      final response = await _apiService.post(
        endpoint: 'user-packages',
        data: {'package_id': packageId},
      );
      return response.data;
    } catch (error) {
      rethrow;
    }
  }
  /// 5️⃣ جلب رصيد محفظة المستخدم الحالي
  Future<double> getMyWalletBalance() async {
    try {
      final response = await _apiService.get(endpoint: 'wallets/my');
      return (response.data['data']['balance'] as num).toDouble();
    } catch (error) {
      rethrow;
    }
  }

  /// 6️⃣ تعديل رصيد المحفظة (خصم أو إضافة)
  Future<void> adjustWalletBalance({required double amount, required String notes}) async {
    try {
      await _apiService.post(
        endpoint: 'wallets/my/adjust',
        data: {
          'amount': amount, // رقم سالب للخصم
          'notes': notes,
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}