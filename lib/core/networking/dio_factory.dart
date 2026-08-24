import 'package:car_care_plus/core/helper/locale_controller.dart';
import 'package:car_care_plus/core/helper/shared_pref_helper.dart';
import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:dio/dio.dart';

class DioFactory {
  /// منع إنشاء كائن من الكلاس يدويًا
  DioFactory._();

  /// نقاط نهاية عامة لا تحتاج توكن، ويجب ألا تحمل توكن جلسة سابقة
  /// وإلا أُرسل طلب تسجيل دخول مستخدم جديد بهوية المستخدم القديم
  static const List<String> _publicPaths = [
    'auth/login',
    'auth/register',
    'auth/password',
  ];

  static bool _isPublicPath(String path) =>
      _publicPaths.any((publicPath) => path.contains(publicPath));

  static Dio getDio() {
    Dio dio = Dio();

    // إعداد المهلة الزمانية والـ BaseUrl
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    // إضافة Interceptor لإدراج الـ Token والـ Headers ومعالجة الأخطاء تلقائياً
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 1. طلب الاستجابة بصيغة JSON دائماً
          options.headers['Accept'] = 'application/json';

          // 2. لغة رسائل الخطأ القادمة من لارافل تتبع لغة الواجهة المختارة
          options.headers['Accept-Language'] = LocaleController.currentLanguageCode;

          // 3. مسارات المصادقة العامة ترسل بدون أي توكن
          if (_isPublicPath(options.path)) {
            options.headers.remove('Authorization');
            return handler.next(options);
          }

          // 4. جلب التوكن المحفوظ
          String token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

          // 5. إرفاق التوكن فقط إذا كان موجوداً وغير فارغ
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },

        
        onError: (DioException error, handler) async {
          // التعامل مع خطأ انتهاء صلاحية التوكن (401)
          if (error.response?.statusCode == 401) {
            // مسح التوكن التالف أو المنتهي من التخزين الآمن
            await SharedPrefHelper.deleteSecuredString(SharedPrefKeys.userToken);
          }

          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
