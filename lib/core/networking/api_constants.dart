class ApiConstants {
  // Base URL الخاص بالسيرفر المحلي عبر XAMPP
  static const String baseUrl = 'http://10.0.2.2:8000/api/';

  // Auth Endpoints
  static const String login = 'login';
  static const String register = 'register';

  // Operations Endpoints (تحديث الصيغ لتطابق لارافيل)
  static const String category = 'categories';     // تعديل من category إلى categories
  static const String service = 'services'; 
  static String servicesByCategory(int categoryId) => 'categories/$categoryId/services';
  static String subServicesByService(int serviceId) => 'services/$serviceId/sub-services';
  static const String carTypes = 'car-types';
  static const String carBrands = 'car-brands';
  static const String package = 'packages';
  static const String userPackage = 'user-packages';
  static const String points = 'points';
  static const String profile = 'profile';
  static const String branche = 'branches';      
  // Cars Endpoints
static const String userCars = 'indexClient'; 
static const String materials = 'materials';
// Booking Endpoints
static const String bookingQuote = 'bookings/quote';
static const String bookingConfirm = 'bookings/confirm';
  // إضافة سيارة جديدة
  // إذا كان المسار داخل لارافيل يتبع operations/car/store:
static const String createCar = ''; 


  // عرض تفاصيل سيارة
  static const String showCar = 'show/'; 

  // تعديل سيارة
  static const String updateCar = 'update/'; 

  // حذف سيارة
  static const String deleteCar = 'delete/';
}