import '../../data/models/auth/user_model.dart';

abstract class AuthRepository {
  /// تسجيل الدخول ثم حفظ الرمز؛ يعيد المستخدم عند النجاح.
  Future<UserModel> login(String emailOrPhone, String password);

  /// تسجيل عميل جديد ثم حفظ الرمز؛ يعيد المستخدم عند النجاح.
  Future<UserModel> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
}
