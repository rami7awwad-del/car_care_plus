import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';

class HomeRepo {
  final ApiService _apiService;

  HomeRepo(this._apiService);

  /// جلب قائمة التصنيفات
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiService.get(endpoint: ApiConstants.category);
    final List data = response.data['data'] as List;
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  /// جلب قائمة الخدمات (إمكانية تصفيتها حسب رقم التصنيف)
  Future<List<ServiceModel>> getServices({int? categoryId}) async {
    final Map<String, dynamic> queryParameters = {};
    if (categoryId != null) {
      queryParameters['category_id'] = categoryId;
    }

    final response = await _apiService.get(
      endpoint: ApiConstants.service,
      queryParameters: queryParameters,
    );
    final List data = response.data['data'] as List;
    return data.map((e) => ServiceModel.fromJson(e)).toList();
  }
}