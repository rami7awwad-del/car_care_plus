class WalletResponseModel {
  final int status;
  final WalletData data;
  final String message;

  WalletResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletResponseModel(
      status: json['status'] ?? 0,
      data: WalletData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class WalletData {
  final int id;
  final int userId;
  final String balance;
  final UserModel? user;
  final String? createdAt;
  final String? updatedAt;

  WalletData({
    required this.id,
    required this.userId,
    required this.balance,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      balance: json['balance']?.toString() ?? '0.00',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;
  final bool isActive;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
    required this.isActive,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? false,
      role: json['role'] ?? '',
    );
  }
}