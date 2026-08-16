class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;
  final bool isActive;
  final String role;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
    required this.isActive,
    required this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['data'] ?? json;

    bool parseIsActive(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      return false;
    }

    return UserModel(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
      imageUrl: userData['image_url'],
      isActive: parseIsActive(userData['is_active']),
      role: userData['role'] ?? '',
      token: userData['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image_url': imageUrl,
      'is_active': isActive,
      'role': role,
      'token': token,
    };
  }
}