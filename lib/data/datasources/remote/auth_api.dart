import '../../../core/constants/api_constants.dart';
import '../../models/auth/auth_response.dart';
import 'dio_client.dart';

/// مصدر البيانات البعيد للمصادقة. يرمي [ApiException] عند الأخطاء (عبر DioClient).
class AuthApi {
  final DioClient _client;

  AuthApi(this._client);

  /// تسجيل الدخول — الحقل email يقبل البريد أو رقم الهاتف (يدعمه الـ backend).
  Future<AuthResult> login(String emailOrPhone, String password) async {
    final res = await _client.post(
      ApiConstants.login,
      data: {'email': emailOrPhone, 'password': password},
    );
    final data = (res.data['data'] as Map).cast<String, dynamic>();
    return AuthResult.fromLogin(data);
  }

  /// تسجيل عميل شخصي — يُفعّل مباشرة ويعيد رمز الوصول.
  Future<AuthResult> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final res = await _client.post(
      ApiConstants.registerCustomer,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
      },
    );
    final data = (res.data['data'] as Map).cast<String, dynamic>();
    return AuthResult.fromRegister(data);
  }
}
