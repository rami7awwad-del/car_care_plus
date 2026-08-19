import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/dio_factory.dart';
import 'package:car_care_plus/features/booking/data/models/booking_confirm_response_model.dart';
import 'package:car_care_plus/features/booking/data/models/booking_quote_response_model.dart';
import 'package:dio/dio.dart';

import '../booking_model.dart';
import '../models/order_status_history_model.dart';
import '../models/rebook_prefill_model.dart';

/// خطأ عملية على الحجز مع رمز الحالة، لأن التمييز بين 409 و403 ضروري:
/// رسائل 409 مترجمة ومخصصة للعرض، بينما رسالة 403 تتحدث عن "التعديل" لا الإلغاء.
class BookingActionException implements Exception {
  final int? statusCode;
  final String message;

  const BookingActionException({required this.statusCode, required this.message});

  /// انتهت مهلة الإلغاء أو الحالة لا تسمح — الرسالة صالحة للعرض كما هي
  bool get isConflict => statusCode == 409;

  @override
  String toString() => message;
}

/// عمليات إعادة الحجز والإلغاء.
///
/// يستخدم Dio مباشرة (بنفس الـ Interceptor الذي يرفق التوكن) بدل ApiService،
/// لأن ApiService يحوّل الأخطاء إلى نص ويفقد رمز الحالة الذي تحتاجه هذه الشاشات.
class OrderActionsRepo {
  final Dio _dio;

  OrderActionsRepo({Dio? dio}) : _dio = dio ?? DioFactory.getDio();

  /// 1. تعبئة نموذج إعادة الحجز (GET /api/bookings/{id}/rebook)
  Future<RebookPrefillModel> getRebookPrefill(int bookingId) async {
    try {
      final response = await _dio.get(ApiConstants.rebookPrefill(bookingId));
      final json = _asMap(response.data);
      _throwIfEnvelopeFailed(json, response.statusCode, 'تعذر تحميل بيانات إعادة الحجز');
      return RebookPrefillModel.fromJson(json);
    } on DioException catch (error) {
      throw _mapError(error, 'تعذر تحميل بيانات إعادة الحجز');
    }
  }

  /// 2. تسعير النموذج بعد التعديل (POST /api/bookings/{id}/rebook/quote)
  ///
  /// قد يعود بشكلين بنفس الحالة 200: تسعيرة فيها quote_token، أو طلب اختيار باقة
  /// (`requires_package_selection`). الموديل يغطي الحالتين.
  Future<QuoteData> getRebookQuote({
    required int bookingId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.rebookQuote(bookingId),
        data: body,
      );
      final json = _asMap(response.data);
      _throwIfEnvelopeFailed(json, response.statusCode, 'تعذر تسعير الحجز');

      final quote = BookingQuoteResponseModel.fromJson(json).data;
      if (quote == null) {
        throw const BookingActionException(
          statusCode: null,
          message: 'لم يصل أي تسعير من السيرفر، حاول مرة أخرى',
        );
      }
      return quote;
    } on DioException catch (error) {
      throw _mapError(error, 'تعذر تسعير الحجز');
    }
  }

  /// 3. تأكيد الحجز الجديد (POST /api/bookings/confirm)
  /// نفس نقطة نهاية الحجز العادي — الرمز يُستهلك مرة واحدة فقط.
  Future<BookingConfirmResponseModel> confirmRebooking(String quoteToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.bookingConfirm,
        data: {'quote_token': quoteToken},
      );
      final json = _asMap(response.data);
      _throwIfEnvelopeFailed(json, response.statusCode, 'تعذر تأكيد الحجز');
      return BookingConfirmResponseModel.fromJson(json);
    } on DioException catch (error) {
      throw _mapError(error, 'تعذر تأكيد الحجز');
    }
  }

  /// 4. إلغاء الحجز (DELETE /api/bookings/{id})
  ///
  /// ⚠️ نقطة النهاية تتطلب جسماً في طلب DELETE يحوي `cancel_reason`،
  /// وإغفاله يعطي 422. لا يوجد حذف فعلي — الحجز ينتقل إلى الحالة cancelled.
  Future<BookingModel> cancelBooking({
    required int bookingId,
    required String cancelReason,
  }) async {
    try {
      final response = await _dio.delete(
        ApiConstants.cancelBooking(bookingId),
        data: {'cancel_reason': cancelReason},
      );
      final json = _asMap(response.data);
      _throwIfEnvelopeFailed(json, response.statusCode, 'تعذر إلغاء الحجز');

      final data = json['data'];
      if (data is Map) {
        return BookingModel.fromJson(Map<String, dynamic>.from(data));
      }
      throw const BookingActionException(
        statusCode: null,
        message: 'تعذر قراءة بيانات الحجز بعد الإلغاء',
      );
    } on DioException catch (error) {
      throw _mapError(error, 'تعذر إلغاء الحجز');
    }
  }

  /// 5. سجل تغيّر حالات الحجز (GET /api/bookings/{id}/status-history)
  ///
  /// مجموعة غير مرقّمة مرتّبة من الأقدم للأحدث، وقصيرة دائماً (٤ أسطر كحد أقصى).
  /// لا تحوي سطراً لإنشاء الحجز — تُبنى تلك المرحلة من `created_at` على الطلب.
  Future<List<OrderStatusHistoryModel>> getStatusHistory(int bookingId) async {
    try {
      final response = await _dio.get(
        ApiConstants.bookingStatusHistory(bookingId),
      );
      final json = _asMap(response.data);
      _throwIfEnvelopeFailed(json, response.statusCode, 'تعذر جلب مراحل الطلب');

      return OrderStatusHistoryResponseModel.fromJson(json).data;
    } on DioException catch (error) {
      throw _mapError(error, 'تعذر جلب مراحل الطلب');
    }
  }

  /// 6. تفاصيل الحجز (GET /api/bookings/{id})
  ///
  /// نجلبه في شاشة التفاصيل بدل الاكتفاء بكائن القائمة: هذا الردّ يحمل
  /// حالة الطلب الحالية وأوقات دورة الحياة كاملة، وقد تكون القائمة قديمة
  /// أو مختصرة.
  Future<BookingModel> getBooking(int bookingId) async {
    try {
      final response = await _dio.get(ApiConstants.showBooking(bookingId));
      final json = _asMap(response.data);
      _throwIfEnvelopeFailed(json, response.statusCode, 'تعذر جلب تفاصيل الطلب');

      final data = json['data'];
      if (data is Map) {
        return BookingModel.fromJson(Map<String, dynamic>.from(data));
      }
      throw const BookingActionException(
        statusCode: null,
        message: 'تعذر قراءة تفاصيل الطلب',
      );
    } on DioException catch (error) {
      throw _mapError(error, 'تعذر جلب تفاصيل الطلب');
    }
  }

  // ==================== أدوات مساعدة ====================

  Map<String, dynamic> _asMap(dynamic data) =>
      data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};

  void _throwIfEnvelopeFailed(
    Map<String, dynamic> json,
    int? statusCode,
    String fallback,
  ) {
    if (json['status'] == 0 || json['status'] == '0') {
      throw BookingActionException(
        statusCode: statusCode,
        message: _readMessage(json) ?? fallback,
      );
    }
  }

  BookingActionException _mapError(DioException error, String fallback) {
    final statusCode = error.response?.statusCode;
    final body = error.response?.data;
    // بعض الردود (active.user) تأتي بجسم عارٍ {message} بلا مغلّف
    final serverMessage =
        body is Map ? _readMessage(Map<String, dynamic>.from(body)) : null;

    // لا يوجد رد أصلاً: مشكلة شبكة أو مهلة
    if (error.response == null) {
      return BookingActionException(
        statusCode: null,
        message: 'تعذر الاتصال بالسيرفر، تحقق من الاتصال وحاول مجدداً',
      );
    }

    return BookingActionException(
      statusCode: statusCode,
      message: switch (statusCode) {
        401 => 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً',
        // رسالة السيرفر هنا تتحدث عن "تعديل" الحجز وهي مربكة في شاشة إلغاء
        403 => 'لا تملك صلاحية تنفيذ هذه العملية على هذا الحجز',
        404 => 'الحجز غير موجود',
        // رسائل التعارض مترجمة ومكتوبة للمستخدم — تُعرض كما هي
        409 => serverMessage ?? 'لا يمكن تنفيذ العملية على هذا الحجز الآن',
        422 => serverMessage ?? 'البيانات المدخلة غير صحيحة',
        _ => serverMessage ?? fallback,
      },
    );
  }

  String? _readMessage(Map<String, dynamic> json) {
    final message = json['message'];
    if (message is String && message.isNotEmpty) return message;
    return null;
  }
}
