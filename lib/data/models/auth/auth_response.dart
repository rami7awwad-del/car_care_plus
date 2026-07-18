import 'user_model.dart';

/// نتيجة المصادقة (مستخدم + رمز الوصول).
/// نقطتا الدخول تختلفان في شكل الاستجابة:
///  - تسجيل الدخول (200): data = { id, name, email, phone, token }
///  - التسجيل (201):     data = { user: { id, name, email, phone }, token }
class AuthResult {
  final UserModel user;
  final String token;

  AuthResult({required this.user, required this.token});

  factory AuthResult.fromLogin(Map<String, dynamic> data) {
    return AuthResult(
      user: UserModel.fromJson(data),
      token: data['token']?.toString() ?? '',
    );
  }

  factory AuthResult.fromRegister(Map<String, dynamic> data) {
    final userJson = (data['user'] as Map?)?.cast<String, dynamic>() ?? const {};
    return AuthResult(
      user: UserModel.fromJson(userJson),
      token: data['token']?.toString() ?? '',
    );
  }
}
