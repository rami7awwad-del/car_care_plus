import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import '../models/material_model.dart';

class MaterialsRepo {
  final ApiService _apiService;

  MaterialsRepo(this._apiService);

  Future<List<MaterialModel>> getMaterials() async {
    final response = await _apiService.get(endpoint: ApiConstants.materials);
    final List data = response.data['data'] as List;
    return data.map((e) => MaterialModel.fromJson(e)).toList();
  }
}