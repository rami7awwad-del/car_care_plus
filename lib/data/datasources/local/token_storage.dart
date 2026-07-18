import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// تخزين آمن لرمز المصادقة (Bearer token) باستخدام flutter_secure_storage.
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<bool> hasToken() async => (await readToken())?.isNotEmpty ?? false;
}
