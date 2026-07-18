import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/datasources/local/token_storage.dart';
import '../../../../data/datasources/remote/api_exception.dart';
import '../../../../data/datasources/remote/auth_api.dart';
import '../../../../data/datasources/remote/dio_client.dart';
import '../../../../data/models/auth/user_model.dart';
import '../../../../data/repositories/auth_repository_impl.dart';
import '../../../../domain/repositories/auth_repository.dart';

// ── الحالات ──────────────────────────────────────────────────────────
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;
  final Map<String, List<String>> fieldErrors;
  const AuthFailure(this.message, {this.fieldErrors = const {}});
}

// ── الـ Cubit ────────────────────────────────────────────────────────
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthInitial());

  /// ينشئ الـ Cubit مع الرسم الافتراضي للاعتماديات (DI يدوي بسيط).
  factory AuthCubit.create() {
    return AuthCubit(AuthRepositoryImpl(AuthApi(DioClient()), TokenStorage()));
  }

  Future<void> login(String emailOrPhone, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(emailOrPhone, password);
      emit(AuthSuccess(user));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message, fieldErrors: e.fieldErrors));
    } catch (_) {
      emit(const AuthFailure('حدث خطأ غير متوقع'));
    }
  }

  Future<void> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.registerCustomer(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      emit(AuthSuccess(user));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message, fieldErrors: e.fieldErrors));
    } catch (_) {
      emit(const AuthFailure('حدث خطأ غير متوقع'));
    }
  }
}
