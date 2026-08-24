import 'package:car_care_plus/features/booking/data/models/booking_confirm_request_body.dart' show BookingConfirmRequestBody;
import 'package:car_care_plus/features/booking/data/models/booking_quote_request_body.dart';
import 'package:car_care_plus/features/booking/data/repos/booking_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo _bookingRepo;

  BookingCubit(this._bookingRepo) : super(BookingInitialState());

  static BookingCubit get(context) => BlocProvider.of(context);

  /// 1. إرسال طلب جلب التسعيرة (Quote)
  Future<void> emitBookingQuote(BookingQuoteRequestBody requestBody) async {
    emit(BookingQuoteLoadingState());

    try {
      final response = await _bookingRepo.getBookingQuote(requestBody);
      emit(BookingQuoteSuccessState(response));
    } catch (error) {
      emit(BookingQuoteErrorState(error.toString()));
    }
  }

  /// 2. إرسال طلب تأكيد الحجز (Confirm)
  Future<void> emitConfirmBooking(String quoteToken) async {
    emit(BookingConfirmLoadingState());

    try {
      final requestBody = BookingConfirmRequestBody(quoteToken: quoteToken);
      final response = await _bookingRepo.confirmBooking(requestBody);
      emit(BookingConfirmSuccessState(response));
    } catch (error) {
      emit(BookingConfirmErrorState(error.toString()));
    }
  }
}