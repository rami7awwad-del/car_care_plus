import 'package:dartz/dartz.dart';
import 'package:car_care_plus/features/auth/data/user_model.dart';

abstract class AuthRepository {
  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<String, UserModel>> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    bool isActive = true,
  });
}