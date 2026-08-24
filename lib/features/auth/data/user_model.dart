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
    final root = json['data'] ?? json;
    // بعض الاستجابات تغلّف بيانات المستخدم داخل مفتاح user بجانب التوكن
    final userData = (root is Map && root['user'] is Map) ? root['user'] : root;

    bool parseIsActive(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
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
      // التوكن قد يصل بجانب بيانات المستخدم أو في جذر الاستجابة وبأسماء مختلفة،
      // لذلك نبحث عنه في كل المستويات بدل الاعتماد على مفتاح واحد
      token: _extractToken(userData) ?? _extractToken(root) ?? _extractToken(json),
    );
  }

  static const List<String> _tokenKeys = [
    'token',
    'access_token',
    'api_token',
    'plainTextToken',
  ];

  static String? _extractToken(dynamic source) {
    if (source is! Map) return null;
    for (final key in _tokenKeys) {
      final value = source[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
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
