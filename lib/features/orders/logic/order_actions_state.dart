import 'package:car_care_plus/features/booking/data/models/booking_quote_response_model.dart';

import '../data/booking_model.dart';
import '../data/models/order_status_history_model.dart';
import '../data/models/rebook_prefill_model.dart';

abstract class OrderActionsState {}

class OrderActionsInitialState extends OrderActionsState {}

// ==================== الإلغاء ====================

class CancelBookingLoadingState extends OrderActionsState {}

class CancelBookingSuccessState extends OrderActionsState {
  /// الحجز بعد الإلغاء — يعود محمّلاً بالكامل فنستخدمه لتحديث الواجهة مباشرة
  final BookingModel cancelledBooking;
  CancelBookingSuccessState(this.cancelledBooking);
}

class CancelBookingErrorState extends OrderActionsState {
  final String message;
  CancelBookingErrorState(this.message);
}

// ==================== مراحل الطلب ====================

class OrderTimelineLoadingState extends OrderActionsState {}

class OrderTimelineSuccessState extends OrderActionsState {
  final List<OrderStatusHistoryModel> history;
  OrderTimelineSuccessState(this.history);
}

/// فشل جلب السجل لا يمنع عرض المراحل: أوقات الطلب وحدها تكفي لرسمها،
/// وينقص فقط اسم من نفّذ كل انتقال.
class OrderTimelineErrorState extends OrderActionsState {
  final String message;
  OrderTimelineErrorState(this.message);
}

// ==================== إعادة الحجز ====================

class RebookPrefillLoadingState extends OrderActionsState {}

class RebookPrefillSuccessState extends OrderActionsState {
  final RebookPrefillModel prefill;
  RebookPrefillSuccessState(this.prefill);
}

class RebookQuoteLoadingState extends OrderActionsState {}

class RebookQuoteSuccessState extends OrderActionsState {
  final QuoteData quote;
  RebookQuoteSuccessState(this.quote);
}

/// التسعير عاد بطلب اختيار باقة بدل تسعيرة — نفس الحالة 200 بلا quote_token
class RebookPackageSelectionState extends OrderActionsState {
  final List<AvailablePackage> availablePackages;
  RebookPackageSelectionState(this.availablePackages);
}

class RebookConfirmLoadingState extends OrderActionsState {}

class RebookConfirmSuccessState extends OrderActionsState {
  final String message;
  final int createdCount;
  RebookConfirmSuccessState({required this.message, required this.createdCount});
}

class RebookErrorState extends OrderActionsState {
  final String message;
  RebookErrorState(this.message);
}
