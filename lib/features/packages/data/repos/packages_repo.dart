import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/features/packages/data/models/package_service_model.dart';

class PackagesRepo {
  final ApiService _apiService;

  PackagesRepo(this._apiService);

  /// 1️⃣ جلب باقات الخدمات من EndPoint /api/package-services
  Future<List<PackageServiceModel>> getPackageServices() async {
    try {
      final response = await _apiService.get(
        endpoint: 'package-services',
      );

      final List data = response.data['data'] as List;
      return data.map((item) => PackageServiceModel.fromJson(item)).toList();
    } catch (error) {
      rethrow;
    }
  }

  /// 2️⃣ الاشتراك في باقة محددة
/// 2️⃣ الاشتراك في باقة محددة
Future<dynamic> subscribeToPackage(int packageId) async {
  try {
    final response = await _apiService.post(
      endpoint: 'user-packages', // أو 'user-packages/$packageId' حسب ما ينص عليه توثيق الـ API
      data: {
        'package_id': packageId, // تمرير הـ ID في الـ Body لحل خطأ "The package id field is required"
      },
    );
    return response.data;
  } catch (error) {
    rethrow;
  }
}



}
