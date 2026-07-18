import 'package:dio/dio.dart';

/// استثناء موحّد لأخطاء الـ API يُقدَّم لطبقة الـ Cubit/UI.
/// يحمل رسالة عامة، وحالة HTTP، وأخطاء التحقق (422) لكل حقل.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  /// أخطاء التحقق من Laravel: { "email": ["..."], "password": ["..."] }
  final Map<String, List<String>> fieldErrors;

  ApiException(this.message, {this.statusCode, this.fieldErrors = const {}});

  bool get isValidationError => statusCode == 422;
  bool get isUnauthorized => statusCode == 401;

  /// أول رسالة خطأ لحقل معيّن (مفيدة لعرضها أسفل حقل الإدخال).
  String? errorFor(String field) => fieldErrors[field]?.isNotEmpty == true ? fieldErrors[field]!.first : null;

  /// يبني [ApiException] من خطأ Dio مع معالجة خاصة للحالة 422 و timeouts.
  factory ApiException.fromDio(DioException e) {
    final response = e.response;
    final int? status = response?.statusCode;
    final data = response?.data;

    // أخطاء التحقق من Laravel (422)
    final Map<String, List<String>> fieldErrors = {};
    if (data is Map && data['errors'] is Map) {
      (data['errors'] as Map).forEach((key, value) {
        if (value is List) {
          fieldErrors[key.toString()] = value.map((v) => v.toString()).toList();
        } else if (value != null) {
          fieldErrors[key.toString()] = [value.toString()];
        }
      });
    }

    // رسالة السيرفر إن وُجدت
    String message;
    if (data is Map && data['message'] is String && (data['message'] as String).isNotEmpty) {
      message = data['message'] as String;
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'انتهت مهلة الاتصال بالخادم';
          break;
        case DioExceptionType.connectionError:
          message = 'تعذّر الاتصال بالخادم';
          break;
        default:
          message = 'حدث خطأ غير متوقع';
      }
    }

    return ApiException(message, statusCode: status, fieldErrors: fieldErrors);
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
