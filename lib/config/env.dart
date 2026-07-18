class Env {
  /// عنوان الـ API الأساسي.
  /// - محاكي أندرويد (Android Emulator): 10.0.2.2 يشير إلى localhost الخاص بالجهاز المضيف.
  /// - جهاز حقيقي: استبدلها بعنوان IP الخاص بجهاز الكمبيوتر مثل http://192.168.1.X:8000/api
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api';

  /// تفعيل تسجيل طلبات/استجابات الشبكة في وضع التطوير.
  static const bool enableLogging = true;
}
