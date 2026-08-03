// جلسة المستخدم الحالية (توكن + بيانات أساسية) محفوظة في الذاكرة
// تُضبط عند نجاح تسجيل الدخول/إنشاء الحساب وتُقرأ في اعتراض Dio والبروفايل
class AuthSession {
  AuthSession._();
  static final AuthSession instance = AuthSession._();

  String? token;
  String? role;
  int? id;
  String? name;
  String? email;
  String? phone;
  String? imageUrl;

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  void setUser({
    String? token,
    String? role,
    int? id,
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
  }) {
    this.token = token;
    this.role = role;
    this.id = id;
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.imageUrl = imageUrl;
  }

  void clear() {
    token = null;
    role = null;
    id = null;
    name = null;
    email = null;
    phone = null;
    imageUrl = null;
  }
}
