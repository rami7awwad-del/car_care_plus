
import 'package:car_care_plus/features/booking/data/models/booking_confirm_response_model.dart';
import 'package:car_care_plus/features/booking/data/models/booking_quote_response_model.dart';

abstract class BookingState {}

/// الحالة الابتدائية
class BookingInitialState extends BookingState {}

// ==================== Quote States ====================

/// جاري طلب التسعيرة
class BookingQuoteLoadingState extends BookingState {}

/// تم جلب التسعيرة بنجاح
class BookingQuoteSuccessState extends BookingState {
  final BookingQuoteResponseModel quoteResponse;

  BookingQuoteSuccessState(this.quoteResponse);
}

/// حدث خطأ أثناء طلب التسعيرة
class BookingQuoteErrorState extends BookingState {
  final String message;

  BookingQuoteErrorState(this.message);
}

// ==================== Confirm States ====================

/// جاري تأكيد الحجز
class BookingConfirmLoadingState extends BookingState {}

/// تم تأكيد الحجز بنجاح
class BookingConfirmSuccessState extends BookingState {
  final BookingConfirmResponseModel confirmResponse;

  BookingConfirmSuccessState(this.confirmResponse);
}

/// حدث خطأ أثناء تأكيد الحجز
class BookingConfirmErrorState extends BookingState {
  final String message;

  BookingConfirmErrorState(this.message);
}