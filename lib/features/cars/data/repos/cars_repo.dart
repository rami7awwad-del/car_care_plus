import 'dart:io';
import 'package:dio/dio.dart';
import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import '../models/car_model.dart';

class CarsRepo {
  final ApiService _apiService;

  CarsRepo(this._apiService);

  /// جلب قائمة سيارات المستخدم
  Future<List<CarModel>> getUserCars() async {
    final response = await _apiService.get(
      endpoint: ApiConstants.userCars,
    );
    final List data = response.data['data'] as List;
    return data.map((e) => CarModel.fromJson(e)).toList();
  }

  /// إضافة سيارة جديدة مع صورة اختيارية
  /// إضافة سيارة جديدة مع صورة اختيارية
Future<CarModel> addCar({
  required Map<String, dynamic> carData,
  File? imageFile,
}) async {
  // 1. تجهيز الخريطة ونقل الحقول لنصوص صريحة
  final Map<String, dynamic> map = {
    'brand_id': carData['brand_id'].toString(),
    'car_type_id': carData['car_type_id'].toString(),
    'plate_number': carData['plate_number'].toString(),
    'model': carData['model'].toString(),
    'year': carData['year'].toString(),
    'color': carData['color'].toString(),
    'fuel_type': carData['fuel_type'].toString(),
    'cylinders': carData['cylinders'].toString(),
    'mileage': carData['mileage'].toString(),
  };

  // 2. إذا وُجدت صورة، أضفها كـ MultipartFile
  if (imageFile != null) {
    map['image'] = await MultipartFile.fromFile(
      imageFile.path,
      filename: imageFile.path.split('/').last,
    );
  }

  // 3. إنشاء الـ FormData
  final formData = FormData.fromMap(map);

  // 4. إرسال الطلب
  final response = await _apiService.post(
    endpoint: ApiConstants.createCar,
    data: formData,
  );

  return CarModel.fromJson(response.data['data']);
}

  /// جلب تفاصيل سيارة
  Future<CarModel> getCarDetails(int carId) async {
    final response = await _apiService.get(
      endpoint: '${ApiConstants.showCar}$carId',
    );
    return CarModel.fromJson(response.data['data']);
  }

  /// تعديل سيارة
  Future<CarModel> updateCar({
    required int carId,
    required Map<String, dynamic> carData,
    File? imageFile,
  }) async {
    final formDataMap = Map<String, dynamic>.from(carData);

    if (imageFile != null) {
      formDataMap['image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    final response = await _apiService.post(
      endpoint: '${ApiConstants.updateCar}$carId',
      data: FormData.fromMap(formDataMap),
    );

    return CarModel.fromJson(response.data['data']);
  }

  /// حذف سيارة
  /// حذف سيارة (السيرفر يتوقع GET)
Future<void> deleteCar(int carId) async {
  await _apiService.get(
    endpoint: '${ApiConstants.deleteCar}$carId',
  );
}

/// جلب قائمة ماركات السيارات
Future<List<Map<String, dynamic>>> getCarBrands() async {
  final response = await _apiService.get(
    endpoint: ApiConstants.carBrands,
  );
  final List data = response.data['data'] as List;
  return List<Map<String, dynamic>>.from(data);
}

/// جلب قائمة أنواع السيارات
Future<List<CarTypeModel>> getCarTypes() async {
  final response = await _apiService.get(
    endpoint: ApiConstants.carTypes,
  );
  final List data = response.data['data'] as List;
  return data.map((e) => CarTypeModel.fromJson(e)).toList();
}

}