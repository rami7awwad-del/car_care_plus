import '../../config/env.dart';

/// روابط ومسارات الـ API. المصدر الأساسي للعنوان هو [Env.apiBaseUrl].
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = Env.apiBaseUrl;

  // Authentication
  static const String login = '/auth/login';
  static const String registerCustomer = '/auth/register/customer';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String sendResetOtp = '/auth/password/otp/send';
  static const String resetWithOtp = '/auth/password/otp/reset';
}
