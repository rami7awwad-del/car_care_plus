import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import '../models/workshop_model.dart';

class WorkshopsRepo {
  final ApiService _apiService;

  WorkshopsRepo(this._apiService);

  /// جلب الورش النشطة القريبة من موقع العميل (مرتّبة بالأقرب)
  Future<List<WorkshopModel>> getNearbyWorkshops({
    required double latitude,
    required double longitude,
    double radiusKm = 20,
  }) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.workshopsNearby,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius_km': radiusKm,
      },
    );
    final List list = response.data['data'] as List;
    return list.map((e) => WorkshopModel.fromJson(e)).toList();
  }
}
