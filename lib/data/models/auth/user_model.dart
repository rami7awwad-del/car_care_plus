class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.token,
  });

  // تحويل الـ JSON القادم من السيرفر إلى Object داخل فلاتر
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      token: json['token'],
    );
  }
}
