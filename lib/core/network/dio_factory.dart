import 'package:dio/dio.dart';
import 'package:car_care_plus/core/network/api_constants.dart';
import 'package:car_care_plus/core/network/auth_session.dart';

// عميل Dio موحّد: يضبط الـ baseUrl والترويسات ويحقن التوكن تلقائياً
Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = AuthSession.instance.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );

  return dio;
}
