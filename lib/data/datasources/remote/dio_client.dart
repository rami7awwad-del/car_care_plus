import 'package:dio/dio.dart';

import '../../../config/env.dart';
import '../../../core/constants/api_constants.dart';
import '../local/token_storage.dart';
import 'api_exception.dart';

/// عميل HTTP مبني على Dio:
/// - يقرأ عنوان الـ API من [ApiConstants.baseUrl].
/// - يضيف رأس المصادقة (Bearer) تلقائياً من [TokenStorage].
/// - يحوّل أخطاء الشبكة إلى [ApiException] (بما فيها التحقق 422).
class DioClient {
  final Dio dio;
  final TokenStorage _tokenStorage;

  DioClient({Dio? dio, TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorage(),
        dio = dio ?? Dio() {
    this.dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // اعتراض الطلبات: إضافة Bearer token عند توفره.
    this.dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await _tokenStorage.readToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              handler.next(options);
            },
          ),
        );

    if (Env.enableLogging) {
      this.dio.interceptors.add(
            LogInterceptor(requestBody: true, responseBody: true, requestHeader: false),
          );
    }
  }

  // ── طرق مساعدة ترمي [ApiException] موحّداً بدلاً من [DioException] ──

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Response> post(String path, {Object? data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Response> put(String path, {Object? data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Response> delete(String path, {Object? data}) async {
    try {
      return await dio.delete(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
