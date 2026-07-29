import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  // دالة تسجيل الدخول
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (userModel) => emit(AuthSuccess(userModel)),
    );
  }

  // دالة إنشاء حساب جديد
  Future<void> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(AuthLoading());

    final result = await authRepository.registerCustomer(
      name: name,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (userModel) => emit(AuthSuccess(userModel)),
    );
  }
}