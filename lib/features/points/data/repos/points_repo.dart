import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import '../models/points_response_model.dart';

class PointsRepo {
  final ApiService _apiService;

  PointsRepo(this._apiService);

  Future<PointsResponseModel> getUserPoints() async {
    final response = await _apiService.get(
      endpoint: ApiConstants.showPoints,
    );
    return PointsResponseModel.fromJson(response.data);
  }
}