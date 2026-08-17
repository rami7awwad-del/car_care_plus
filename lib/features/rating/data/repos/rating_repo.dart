import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import '../models/rating_model.dart';

class RatingRepo {
  final ApiService _apiService;

  RatingRepo(this._apiService);

  /// قائمة تقييماتي (مُرقّمة صفحات — العناصر في data.data)
  Future<List<RatingModel>> getMyRatings({int perPage = 15}) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.ratings,
      queryParameters: {'per_page': perPage},
    );
    final List list = response.data['data']['data'] as List;
    return list.map((e) => RatingModel.fromJson(e)).toList();
  }

  /// تفاصيل تقييم
  Future<RatingModel> getRatingDetails(int id) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.ratingById(id),
    );
    return RatingModel.fromJson(response.data['data']);
  }

  /// إنشاء تقييم (employee_id يُلتقط تلقائياً من الطلب — لا يُرسل)
  Future<RatingModel> createRating(Map<String, dynamic> ratingData) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.ratings,
      data: ratingData,
    );
    return RatingModel.fromJson(response.data['data']);
  }

  /// تعديل تقييم (POST لا PUT — الحقول المُرسَلة فقط)
  Future<RatingModel> updateRating({
    required int id,
    required Map<String, dynamic> ratingData,
  }) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.ratingById(id),
      data: ratingData,
    );
    return RatingModel.fromJson(response.data['data']);
  }
}
