// lib/features/auth/presentation/cubit/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_care_plus/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await authRepository.login(email: email, password: password);
    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (userModel) => emit(AuthSuccess(userModel)),
    );
  }

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

  Future<void> registerCompany({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String companyName,
    required String companyNameAr,
    required String commercialReg,
    required String taxNumber,
    required String companyAddress,
  }) async {
    emit(AuthLoading());
    final result = await authRepository.registerCompany(
      name: name,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
      companyName: companyName,
      companyNameAr: companyNameAr,
      commercialReg: commercialReg,
      taxNumber: taxNumber,
      companyAddress: companyAddress,
    );
    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (userModel) => emit(AuthSuccess(userModel)),
    );
  }

  // 🆕 دالة طلب الـ OTP
  Future<void> sendResetOtp({required String email}) async {
    emit(AuthLoading());
    final result = await authRepository.sendResetOtp(email: email);
    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (successMessage) => emit(SendOtpSuccess(successMessage)),
    );
  }

  // 🆕 دالة إرسال الـ OTP وكلمة المرور الجديدة للتأكيد
  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(AuthLoading());
    final result = await authRepository.resetPasswordWithOtp(
      email: email,
      otp: otp,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (successMessage) => emit(ResetPasswordSuccess(successMessage)),
    );
  }
}
