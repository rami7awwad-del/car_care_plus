import 'package:car_care_plus/features/auth/data/user_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    bool isActive = true,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  // 🔗 الـ IP المخصص للمحاكي للوصول للـ Localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'فشل تسجيل الدخول');
      }
    } on DioException catch (e) {
      // ⚠️ التقاط أخطاء الشبكة والـ Timeouts وإعادة صياغتها رسالة مفيدة
      throw Exception(
        e.response?.data['message'] ??
            'تعذر الاتصال بالسيرفر، تأكد من تشغيل Laravel',
      );
    }
  }

  @override
  Future<UserModel> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    bool isActive = true,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/register/customer',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'is_active': isActive,
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['status'] == 1) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'فشل إنشاء الحساب');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'تعذر الاتصال بالسيرفر، تأكد من تشغيل Laravel',
      );
    }
  }
}