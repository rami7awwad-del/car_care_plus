class ApiConstants {
  // Base URL الخاص بالسيرفر المحلي عبر XAMPP
  static const String baseUrl = 'http://10.0.2.2:8000/api/';

  // Auth Endpoints
  static const String login = 'login';
  static const String register = 'register';

  // Operations Endpoints (تحديث الصيغ لتطابق لارافيل)
  static const String category = 'categories';     // تعديل من category إلى categories
  static const String service = 'services';         // تعديل من service إلى services
  static const String subServices = 'sub-services'; // أو subServices حسب ما هو معرف في لارافيل
  static const String carTypes = 'car-types';
  static const String carBrands = 'car-brands';
  static const String package = 'packages';
  static const String userPackage = 'user-packages';
  static const String points = 'points';
  static const String profile = 'profile';
  static const String branche = 'branches';         // تعديل من branche إلى branches
}