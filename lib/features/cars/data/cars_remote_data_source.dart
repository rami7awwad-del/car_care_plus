import 'package:dio/dio.dart';
import 'package:car_care_plus/core/network/api_constants.dart';
import 'package:car_care_plus/features/cars/data/car_model.dart';

abstract class CarsRemoteDataSource {
  Future<List<Car>> getMyCars();
  Future<Car> getCarDetails(int id);
  Future<void> deleteCar(int id);
}

class CarsRemoteDataSourceImpl implements CarsRemoteDataSource {
  final Dio dio;

  CarsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Car>> getMyCars() async {
    try {
      final response = await dio.get(ApiConstants.myCars);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        final list = (response.data['data'] as List?) ?? [];
        return list
            .map((e) => Car.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'فشل جلب السيارات');
      }
    } on DioException catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  @override
  Future<Car> getCarDetails(int id) async {
    try {
      final response = await dio.get(ApiConstants.carShow(id));

      if (response.statusCode == 200 && response.data['status'] == 1) {
        return Car.fromJson(response.data['data'] as Map<String, dynamic>);
      } else {
        throw Exception(response.data['message'] ?? 'فشل جلب بيانات السيارة');
      }
    } on DioException catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  @override
  Future<void> deleteCar(int id) async {
    try {
      // ⚠️ الحذف عبر GET حسب تصميم الـ Back-end
      final response = await dio.get(ApiConstants.carDelete(id));

      if (response.statusCode == 200 && response.data['status'] == 1) {
        return;
      } else {
        throw Exception(response.data['message'] ?? 'فشل حذف السيارة');
      }
    } on DioException catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  String _messageFromError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return 'تعذر الاتصال بالسيرفر، تأكد من الاتصال';
  }
}
