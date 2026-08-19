// lib/features/auth/data/auth_repository_impl.dart

import 'package:car_care_plus/core/helper/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care_plus/features/auth/data/auth_remote_data_source.dart';
import 'package:car_care_plus/features/auth/data/user_model.dart';
import 'package:car_care_plus/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      // مسح توكن الجلسة السابقة قبل أي محاولة دخول.
      // بدون هذا السطر يبقى توكن المستخدم السابق فعّالاً إذا لم يُحفظ التوكن
      // الجديد، فتُنفَّذ كل الطلبات التالية (ومنها جلب البروفايل) بهويته.
      await SharedPrefHelper.deleteSecuredString(SharedPrefKeys.userToken);

      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );

      final token = user.token;
      if (token == null || token.isEmpty) {
        // نفشل بوضوح بدل المتابعة بلا توكن أو بتوكن مستخدم آخر
        return const Left(
          'تعذر الحصول على رمز الدخول من السيرفر، يرجى المحاولة مرة أخرى',
        );
      }

      await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);

      return Right(user);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<Either<String, UserModel>> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    bool isActive = true,
  }) async {
    try {
      // حساب جديد يجب ألا يرث جلسة المستخدم السابق
      await SharedPrefHelper.deleteSecuredString(SharedPrefKeys.userToken);
      final user = await remoteDataSource.registerCustomer(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        isActive: isActive,
      );
      await _persistTokenIfPresent(user);
      return Right(user);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<Either<String, UserModel>> registerCompany({
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
    bool isActive = false,
  }) async {
    try {
      // حساب جديد يجب ألا يرث جلسة المستخدم السابق
      await SharedPrefHelper.deleteSecuredString(SharedPrefKeys.userToken);
      final user = await remoteDataSource.registerCompany(
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
        isActive: isActive,
      );
      await _persistTokenIfPresent(user);
      return Right(user);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  
  @override
  Future<Either<String, String>> sendResetOtp({required String email}) async {
    try {
      final message = await remoteDataSource.sendResetOtp(email: email);
      return Right(message);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<Either<String, String>> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final message = await remoteDataSource.resetPasswordWithOtp(
        email: email,
        otp: otp,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return Right(message);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
Future<Either<String, UserModel>> getProfile() async {
  try {
    final user = await remoteDataSource.getProfile();
    return Right(user);
  } catch (e) {
    return Left(e.toString().replaceAll('Exception: ', ''));
  }
}

@override
Future<Either<String, UserModel>> updateProfile({
  String? name,
  String? email,
  String? phone,
  String? imagePath,
}) async {
  try {
    final user = await remoteDataSource.updateProfile(
      name: name,
      email: email,
      phone: phone,
      imagePath: imagePath,
    );
    return Right(user);
  } catch (e) {
    return Left(e.toString().replaceAll('Exception: ', ''));
  }
}


  /// يحفظ التوكن إن أرسله السيرفر. التسجيل قد لا يعيد توكناً (حساب شركة بانتظار
  /// الموافقة مثلاً)، وعندها يبقى المستخدم بلا جلسة بدل أن يرث جلسة غيره.
  Future<void> _persistTokenIfPresent(UserModel user) async {
    final token = user.token;
    if (token != null && token.isNotEmpty) {
      await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
    }
  }
}
