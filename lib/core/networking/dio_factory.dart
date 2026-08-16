import 'package:car_care_plus/core/helper/shared_pref_helper.dart';
import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:dio/dio.dart';

class DioFactory {
  /// منع إنشاء كائن من الكلاس يدويًا
  DioFactory._();

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

          // 2. جلب التوكن المحفوظ
          String token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

          // 3. إرفاق التوكن فقط إذا كان موجوداً وغير فارغ
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