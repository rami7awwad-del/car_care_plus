class ApiConstants {
  // Base URL الخاص بالسيرفر المحلي عبر XAMPP
  static const String baseUrl = 'http://10.0.2.2:8000/api/';

  // Auth Endpoints
  static const String login = 'login';
  static const String register = 'register';

  // Operations Endpoints
  static const String category = 'categories';
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
  static String branchById(int id) => 'branches/$id';
static const String showPoints = 'points/show';
  // Wallet & Payments Endpoints
  static const String myWallet = 'wallets/my';
  static const String payments = 'payments';
  static String showPayment(int paymentId) => 'payments/$paymentId';
  static String walletTransactions({int? customerId}) =>
      customerId != null ? 'wallet-transactions/$customerId' : 'wallet-transactions';
  static String showWalletTransaction(int transactionId) =>
      'wallet-transactions/show/$transactionId';

  // Cars Endpoints
  static const String userCars = 'indexClient';
  static const String materials = 'materials';

  // Booking Endpoints
  static const String bookingQuote = 'bookings/quote';
  static const String bookingConfirm = 'bookings/confirm';
// في كلاس ApiConstants
static const String userBookings = 'bookings'; // أو المسار الخاص بقائمة حجوزات الزبون لديك
static String showBooking(int id) => 'bookings/$id';

  // Rebooking & Cancellation Endpoints
  static String rebookPrefill(int id) => 'bookings/$id/rebook';        // (GET)
  static String rebookQuote(int id) => 'bookings/$id/rebook/quote';    // (POST)
  static String cancelBooking(int id) => 'bookings/$id';               // (DELETE + body)
  static String bookingStatusHistory(int id) => 'bookings/$id/status-history'; // (GET)
  // Workshops (لاختيار ورشة الصيانة)
  static const String workshopsNearby = 'workshops/nearby';

  // Car Management Endpoints
  static const String createCar = '';
  static const String showCar = 'show/';
  static const String updateCar = 'update/';
  static const String deleteCar = 'delete/';

  // Ratings Endpoints
  static const String ratings = 'ratings';           // قائمتي (GET) + إنشاء (POST)
  static String ratingById(int id) => 'ratings/$id'; // تفاصيل (GET) + تعديل (POST)

  // Notifications Endpoints
  static const String notifications = 'notifications';                    // القائمة (GET)
  static const String unreadNotificationsCount = 'notifications/unread-count';
  static const String readAllNotifications = 'notifications/read-all';    // (POST)
  static String showNotification(int id) => 'notifications/$id';
  static String readNotification(int id) => 'notifications/$id/read';     // (POST)
}