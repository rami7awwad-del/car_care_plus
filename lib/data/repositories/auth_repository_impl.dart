import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/token_storage.dart';
import '../datasources/remote/auth_api.dart';
import '../models/auth/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._api, this._tokenStorage);

  @override
  Future<UserModel> login(String emailOrPhone, String password) async {
    final result = await _api.login(emailOrPhone, password);
    await _tokenStorage.saveToken(result.token);
    return result.user;
  }

  @override
  Future<UserModel> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final result = await _api.registerCustomer(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    await _tokenStorage.saveToken(result.token);
    return result.user;
  }
}
