import 'booking_model.dart';
import 'models/order_status_history_model.dart';
import 'order_rules.dart';

enum OrderStageKey { placed, assigned, inProgress, completed, cancelled }

/// حالة المرحلة في الخط الزمني
enum OrderStageState {
  /// حدثت فعلاً ولها وقت
  done,

  /// المرحلة الحالية التي يقف عندها الطلب
  current,

  /// لم تحدث بعد
  upcoming,
}

class OrderStage {
  final OrderStageKey key;
  final String title;
  final OrderStageState state;
  final DateTime? at;

  /// اسم الفني الذي نفّذ الانتقال، أو null إذا نفّذه الزبون أو الإدارة
  final String? actorName;

  /// نص إضافي أسفل المرحلة (سبب الإلغاء مثلاً)
  final String? detail;

  const OrderStage({
    required this.key,
    required this.title,
    required this.state,
    this.at,
    this.actorName,
    this.detail,
  });

  bool get isDone => state == OrderStageState.done;
  bool get isCurrent => state == OrderStageState.current;
}

/// يبني مراحل دورة حياة الحجز من مصدرين معاً:
///
/// - **أوقات الطلب** (`created_at` / `assigned_at` / …) للأوقات والمدد،
///   فهي موجودة دائماً وتأتي بطلب واحد.
/// - **سجل الحالات** لمعرفة *من* نفّذ كل انتقال.
///
/// السجل لا يحتوي سطراً لإنشاء الحجز إطلاقاً، لذلك نبني مرحلة "تم إنشاء الطلب"
/// من `created_at`، وإلا بدأ الخط الزمني من منتصفه.
class OrderTimeline {
  const OrderTimeline._();

  static const Map<OrderStageKey, String> _titles = {
    OrderStageKey.placed: 'تم إنشاء الطلب',
    OrderStageKey.assigned: 'تم تعيين فني',
    OrderStageKey.inProgress: 'بدأ التنفيذ',
    OrderStageKey.completed: 'اكتمل الطلب',
    OrderStageKey.cancelled: 'تم إلغاء الطلب',
  };

  static List<OrderStage> build(
    BookingModel order,
    List<OrderStatusHistoryModel> history,
  ) {
    final actors = _actorsByStatus(history);
    final status = OrderRules.normalizeStatus(order.status);
    final isCancelled = status == 'cancelled';

    // الأوقات للعرض فقط. **حالة الطلب هي مصدر الحقيقة للتقدّم**، لأن أي وقت
    // قد يصل فارغاً (لا ترسله بعض النقاط، أو غيّرت الحالة عملية لم تسجّله)
    // وغيابه لا يعني أن المرحلة لم تحدث.
    final times = <OrderStageKey, DateTime?>{
      OrderStageKey.placed: order.createdAt,
      OrderStageKey.assigned: order.assignedAt,
      OrderStageKey.inProgress: order.startedAt,
      OrderStageKey.completed: order.completedAt,
    };

    final actorKeys = <OrderStageKey, String>{
      OrderStageKey.assigned: 'assigned',
      OrderStageKey.inProgress: 'in_progress',
      OrderStageKey.completed: 'completed',
    };

    final reachedIndex = isCancelled
        ? _reachedIndexWhenCancelled(order, history)
        : _reachedIndexFor(status);

    final stages = <OrderStage>[];

    for (var index = 0; index < _sequence.length; index++) {
      final key = _sequence[index];

      // الطلب الملغى لا يعرض مرحلة اكتمال لم تحدث
      if (isCancelled && key == OrderStageKey.completed) continue;

      final OrderStageState state;
      if (index < reachedIndex) {
        state = OrderStageState.done;
      } else if (index == reachedIndex) {
        // المرحلة الأخيرة التي بلغها الطلب: حالية إلا إذا كان ملغى،
        // فالمرحلة الحالية حينها هي الإلغاء نفسه
        state = isCancelled ? OrderStageState.done : OrderStageState.current;
      } else {
        state = OrderStageState.upcoming;
      }

      stages.add(
        OrderStage(
          key: key,
          title: _titles[key]!,
          state: state,
          at: times[key],
          actorName: actorKeys[key] == null ? null : actors[actorKeys[key]],
        ),
      );
    }

    if (isCancelled) {
      stages.add(
        OrderStage(
          key: OrderStageKey.cancelled,
          title: _titles[OrderStageKey.cancelled]!,
          state: OrderStageState.current,
          at: order.cancelledAt,
          actorName: actors['cancelled'],
          // سبب الإلغاء يأتي من الطلب لا من سجل الحالات
          detail: order.cancelReason?.trim().isNotEmpty == true
              ? order.cancelReason!.trim()
              : null,
        ),
      );
    }

    return stages;
  }

  /// ترتيب المراحل في دورة الحياة
  static const List<OrderStageKey> _sequence = [
    OrderStageKey.placed,
    OrderStageKey.assigned,
    OrderStageKey.inProgress,
    OrderStageKey.completed,
  ];

  /// آخر مرحلة بلغها الطلب حسب حالته
  static int _reachedIndexFor(String status) {
    switch (status) {
      case 'assigned':
        return 1;
      case 'in_progress':
        return 2;
      case 'completed':
        return 3;
      case 'pending':
      default:
        // أي حالة غير معروفة تُعامل كطلب جديد بدل كسر الخط الزمني
        return 0;
    }
  }

  /// الطلب الملغى لا تدل حالته على المرحلة التي وقف عندها.
  /// سطر الإلغاء في السجل يحمل `from_status` وهو أدقّ مصدر، وإلا نستدل
  /// بالأوقات المتاحة.
  static int _reachedIndexWhenCancelled(
    BookingModel order,
    List<OrderStatusHistoryModel> history,
  ) {
    for (final row in history) {
      if (row.toStatus == 'cancelled' && row.fromStatus.isNotEmpty) {
        return _reachedIndexFor(row.fromStatus);
      }
    }

    if (order.startedAt != null) return 2;
    if (order.assignedAt != null) return 1;
    return 0;
  }

  /// من نفّذ كل انتقال، حسب `to_status`.
  /// السجل ثانوي الدقة، لذلك نرتّب بالوقت ثم بالمعرّف لفكّ التعادل.
  static Map<String, String?> _actorsByStatus(
    List<OrderStatusHistoryModel> history,
  ) {
    final sorted = [...history]..sort((a, b) {
      final aTime = a.createdAt;
      final bTime = b.createdAt;
      if (aTime != null && bTime != null) {
        final byTime = aTime.compareTo(bTime);
        if (byTime != 0) return byTime;
      }
      return a.id.compareTo(b.id);
    });

    final actors = <String, String?>{};
    for (final row in sorted) {
      // انتقال بلا معرّف موظف يعني أن الزبون أو الإدارة نفّذه،
      // والـ API لا يخبرنا من بالضبط
      actors[row.toStatus] = row.isByEmployee ? row.employeeName : null;
    }
    return actors;
  }

  // ==================== المدد ====================
  // لا تُخزَّن أي مدة في الباك اند ولا يوجد وقت إنجاز متوقّع

  static Duration? _between(DateTime? from, DateTime? to) {
    if (from == null || to == null) return null;
    return to.difference(from);
  }

  /// مدة تنفيذ العمل الفعلي
  static Duration? workDuration(BookingModel order) =>
      _between(order.startedAt, order.completedAt);

  /// مدة الانتظار حتى تعيين فني
  static Duration? waitToAssign(BookingModel order) =>
      _between(order.createdAt, order.assignedAt);

  /// الفارق بين الموعد الموعود وبدء التنفيذ.
  /// موجب = تأخّر، سالب = بدأ مبكراً.
  static Duration? punctuality(BookingModel order) {
    final scheduled = OrderRules.scheduledAt(order);
    return _between(scheduled, order.startedAt);
  }

  /// الوقت المنقضي منذ بدء التنفيذ لطلب ما زال جارياً
  static Duration? elapsedSinceStart(BookingModel order) {
    if (OrderRules.normalizeStatus(order.status) != 'in_progress') return null;
    final started = order.startedAt;
    if (started == null) return null;
    return DateTime.now().difference(started);
  }

  /// صياغة المدة بالعربية
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.abs();
    if (minutes < 1) return 'أقل من دقيقة';
    if (minutes < 60) return _plural(minutes, 'دقيقة', 'دقيقتين', 'دقائق');

    final hours = duration.inHours.abs();
    final restMinutes = minutes % 60;
    final hoursText = _plural(hours, 'ساعة', 'ساعتين', 'ساعات');
    if (hours < 24) {
      return restMinutes == 0
          ? hoursText
          : '$hoursText و${_plural(restMinutes, 'دقيقة', 'دقيقتين', 'دقائق')}';
    }

    final days = duration.inDays.abs();
    return _plural(days, 'يوم', 'يومين', 'أيام');
  }

  static String _plural(int count, String one, String two, String many) {
    if (count == 1) return one;
    if (count == 2) return two;
    if (count <= 10) return '$count $many';
    return '$count $one';
  }
}
