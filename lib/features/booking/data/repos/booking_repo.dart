import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_error_handler.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/features/booking/data/models/booking_confirm_request_body.dart';
import 'package:car_care_plus/features/booking/data/models/booking_confirm_response_model.dart';
import 'package:car_care_plus/features/booking/data/models/booking_quote_request_body.dart';
import 'package:car_care_plus/features/booking/data/models/booking_quote_response_model.dart';

class BookingRepo {
  final ApiService _apiService;





  BookingRepo(this._apiService);

  /// 1. طلب تسعيرة الحجز (Quote)
  Future<BookingQuoteResponseModel> getBookingQuote(
    BookingQuoteRequestBody requestBody,
  ) async {
    try {
      final response = await _apiService.post(
        endpoint: ApiConstants.bookingQuote,
        data: requestBody.toFormData(), // 👈 التعديل هنا: استخدام toFormData() بدلاً من toJson()
      );
      // أضف هذا السطر لمشاهدة المخرجات في الـ Console
     


      return BookingQuoteResponseModel.fromJson(response.data);
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  /// 2. تأكيد الحجز (Confirm)
  Future<BookingConfirmResponseModel> confirmBooking(
    BookingConfirmRequestBody requestBody,
  ) async {
    try {
      final response = await _apiService.post(
        endpoint: ApiConstants.bookingConfirm,
        data: requestBody.toJson(),
      );
      return BookingConfirmResponseModel.fromJson(response.data);
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }
  
}