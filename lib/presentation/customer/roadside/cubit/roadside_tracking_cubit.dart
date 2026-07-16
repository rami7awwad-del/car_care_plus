import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/roadside_models.dart';

class RoadsideTrackingState {
  final TrackingStatus status;
  final RoadsideEmployee? employee;
  final bool cancelled;

  const RoadsideTrackingState({
    this.status = TrackingStatus.searching,
    this.employee,
    this.cancelled = false,
  });

  /// حسب BR-13: لا يمكن إلغاء طلب الطوارئ إلا خلال فترة قصيرة جداً (مرحلة البحث).
  bool get canCancel => status == TrackingStatus.searching && !cancelled;

  bool get isCompleted => status == TrackingStatus.completed;

  RoadsideTrackingState copyWith({
    TrackingStatus? status,
    RoadsideEmployee? employee,
    bool? cancelled,
  }) {
    return RoadsideTrackingState(
      status: status ?? this.status,
      employee: employee ?? this.employee,
      cancelled: cancelled ?? this.cancelled,
    );
  }
}

/// يحاكي تقدّم الطلب عبر الحالات باستخدام مؤقتات (mock — بدلاً من WebSocket لاحقاً).
class RoadsideTrackingCubit extends Cubit<RoadsideTrackingState> {
  RoadsideTrackingCubit() : super(const RoadsideTrackingState());

  static const _mockEmployee = RoadsideEmployee(
    name: 'خالد العتيبي',
    rating: 4.8,
    vehicle: 'تويوتا هايلكس',
    plate: 'ر ب س 4213',
    etaMinutes: 8,
  );

  /// يبدأ محاكاة رحلة الطلب. يتوقف تلقائياً إذا أُغلق الـ Cubit أو أُلغي الطلب.
  Future<void> start() async {
    await _advanceAfter(3, TrackingStatus.assigned, employee: _mockEmployee);
    await _advanceAfter(2, TrackingStatus.enRoute);
    await _advanceAfter(5, TrackingStatus.arrived);
    await _advanceAfter(2, TrackingStatus.inProgress);
    await _advanceAfter(5, TrackingStatus.completed);
  }

  Future<void> _advanceAfter(int seconds, TrackingStatus status, {RoadsideEmployee? employee}) async {
    await Future.delayed(Duration(seconds: seconds));
    if (isClosed || state.cancelled) return;
    emit(state.copyWith(status: status, employee: employee));
  }

  void cancel() {
    if (state.canCancel) emit(state.copyWith(cancelled: true));
  }
}
