import 'package:car_care_plus/features/booking/data/models/booking_quote_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/booking_model.dart';
import '../data/models/order_status_history_model.dart';
import '../data/models/rebook_prefill_model.dart';
import '../data/repos/order_actions_repo.dart';
import 'order_actions_state.dart';

class OrderActionsCubit extends Cubit<OrderActionsState> {
  final OrderActionsRepo _repo;

  OrderActionsCubit(this._repo) : super(OrderActionsInitialState());

  /// نموذج إعادة الحجز المحمّل، تحتفظ به الشاشة لبناء جسم التسعيرة
  RebookPrefillModel? prefill;

  /// آخر تسعيرة ناجحة — الرمز يُستهلك مرة واحدة عند التأكيد
  QuoteData? quote;

  /// سجل الحالات المحمّل — نحتفظ به لأن الشاشة تعيد البناء عند كل حالة جديدة
  List<OrderStatusHistoryModel> statusHistory = const [];

  bool _isBusy = false;

  void _safeEmit(OrderActionsState state) {
    if (!isClosed) emit(state);
  }

  // ==================== مراحل الطلب ====================

  /// نسخة محدّثة من الطلب من نقطة التفاصيل، إن نجح جلبها
  BookingModel? freshOrder;

  /// يجلب تفاصيل الطلب وسجل الحالات معاً:
  ///
  /// - **التفاصيل** تحمل الحالة الحالية وأوقات دورة الحياة كاملة، وقد تنقص
  ///   في كائن القائمة أو تكون قديمة.
  /// - **السجل** يضيف اسم من نفّذ كل انتقال فقط.
  ///
  /// فشل أيٍّ منهما لا يمنع رسم المراحل: الحالة وحدها تكفي لتحديد التقدّم.
  Future<void> loadOrderTimeline(int bookingId) async {
    _safeEmit(OrderTimelineLoadingState());

    final orderFuture = _repo.getBooking(bookingId);
    final historyFuture = _repo.getStatusHistory(bookingId);

    try {
      freshOrder = await orderFuture;
    } catch (_) {
      // نبقى على كائن الطلب القادم من القائمة
    }

    try {
      statusHistory = await historyFuture;
      _safeEmit(OrderTimelineSuccessState(statusHistory));
    } on BookingActionException catch (error) {
      _safeEmit(OrderTimelineErrorState(error.message));
    } catch (error) {
      _safeEmit(OrderTimelineErrorState(error.toString()));
    }
  }

  // ==================== إلغاء الحجز ====================

  Future<void> cancelBooking({
    required int bookingId,
    required String cancelReason,
  }) async {
    if (_isBusy) return;
    _isBusy = true;

    _safeEmit(CancelBookingLoadingState());
    try {
      final cancelled = await _repo.cancelBooking(
        bookingId: bookingId,
        cancelReason: cancelReason,
      );
      _safeEmit(CancelBookingSuccessState(cancelled));
    } on BookingActionException catch (error) {
      _safeEmit(CancelBookingErrorState(error.message));
    } catch (error) {
      _safeEmit(CancelBookingErrorState(error.toString()));
    } finally {
      _isBusy = false;
    }
  }

  // ==================== إعادة الحجز ====================

  Future<void> loadRebookForm(int bookingId) async {
    _safeEmit(RebookPrefillLoadingState());
    try {
      final loaded = await _repo.getRebookPrefill(bookingId);
      prefill = loaded;
      _safeEmit(RebookPrefillSuccessState(loaded));
    } on BookingActionException catch (error) {
      _safeEmit(RebookErrorState(error.message));
    } catch (error) {
      _safeEmit(RebookErrorState(error.toString()));
    }
  }

  /// يسعّر النموذج بعد تعديل المستخدم.
  /// قد يعود بطلب اختيار باقة بدل تسعيرة، لذلك نفحص العلم قبل قراءة الرمز.
  Future<void> requestQuote({
    required int bookingId,
    required bool isImmediate,
    required DateTime? scheduledAt,
    required String paymentMethod,
    required bool isVip,
    required String notes,
    int? userPackageId,
  }) async {
    final form = prefill;
    if (form == null || _isBusy) return;
    _isBusy = true;

    _safeEmit(RebookQuoteLoadingState());
    try {
      final body = form.buildQuoteBody(
        isImmediate: isImmediate,
        scheduledAt: scheduledAt,
        paymentMethod: paymentMethod,
        isVip: isVip,
        notes: notes,
        userPackageId: userPackageId,
      );

      final result = await _repo.getRebookQuote(bookingId: bookingId, body: body);

      if (result.requiresPackageSelection) {
        quote = null;
        _safeEmit(RebookPackageSelectionState(result.availablePackages));
        return;
      }

      quote = result;
      _safeEmit(RebookQuoteSuccessState(result));
    } on BookingActionException catch (error) {
      _safeEmit(RebookErrorState(error.message));
    } catch (error) {
      _safeEmit(RebookErrorState(error.toString()));
    } finally {
      _isBusy = false;
    }
  }

  Future<void> confirmRebooking() async {
    final token = quote?.quoteToken;
    if (token == null || token.isEmpty || _isBusy) return;
    _isBusy = true;

    _safeEmit(RebookConfirmLoadingState());
    try {
      final response = await _repo.confirmRebooking(token);
      // الرمز يُستهلك عند أول تأكيد، فإعادة إرساله تعطي 422
      quote = null;
      _safeEmit(
        RebookConfirmSuccessState(
          message: response.message.isNotEmpty
              ? response.message
              : 'تم تأكيد الحجز بنجاح',
          createdCount: response.data?.length ?? 0,
        ),
      );
    } on BookingActionException catch (error) {
      _safeEmit(RebookErrorState(error.message));
    } catch (error) {
      _safeEmit(RebookErrorState(error.toString()));
    } finally {
      _isBusy = false;
    }
  }

  /// التسعيرة صالحة 15 دقيقة فقط
  bool get isQuoteExpired {
    final expiresAt = quote?.expiresAt;
    if (expiresAt == null) return false;
    final date = DateTime.tryParse(expiresAt);
    if (date == null) return false;
    return DateTime.now().isAfter(date.toLocal());
  }
}
