import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';

import '../models/branch_model.dart';

class BranchesRepo {
  final ApiService _apiService;

  BranchesRepo(this._apiService);

  /// قائمة الفروع (GET /api/branches).
  ///
  /// لا يوجد أي بحث أو تصفية أو ترتيب من جهة السيرفر — فقط `per_page` و`page`.
  /// القائمة صغيرة عادةً، لذلك نجلبها بصفحة واحدة كبيرة ونصفّي ونرتّب محلياً.
  Future<BranchesResponseModel> getBranches({
    int page = 1,
    int perPage = 50,
  }) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.branche,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return BranchesResponseModel.fromJson(
      response.data is Map
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{},
    );
  }

  /// تفاصيل فرع (GET /api/branches/{id}).
  ///
  /// الردّ مطابق تماماً لصف القائمة، فلا داعي لاستدعائه لفتح شاشة التفاصيل —
  /// يُستخدم للتحديث فقط.
  Future<BranchModel?> getBranch(int branchId) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.branchById(branchId),
    );

    final json = response.data;
    if (json is Map && json['data'] is Map) {
      return BranchModel.fromJson(Map<String, dynamic>.from(json['data']));
    }
    return null;
  }
}
