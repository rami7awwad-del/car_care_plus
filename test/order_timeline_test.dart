import 'package:car_care_plus/features/orders/data/booking_model.dart';
import 'package:car_care_plus/features/orders/data/models/order_status_history_model.dart';
import 'package:car_care_plus/features/orders/data/order_timeline.dart';
import 'package:flutter_test/flutter_test.dart';

BookingModel _order({
  String status = 'completed',
  String? createdAt = '2026-08-18T08:00:00+00:00',
  String? assignedAt = '2026-08-18T08:40:00+00:00',
  String? startedAt = '2026-08-18T09:12:33+00:00',
  String? completedAt = '2026-08-18T10:05:10+00:00',
  String? cancelledAt,
  String? cancelReason,
  String? scheduledAt = '2026-08-18T09:00:00+00:00',
}) {
  return BookingModel.fromJson({
    'id': 482,
    'status': status,
    'total_price': '210.00',
    'scheduled_at': scheduledAt,
    'created_at': createdAt,
    'assigned_at': assignedAt,
    'started_at': startedAt,
    'completed_at': completedAt,
    'cancelled_at': cancelledAt,
    'cancel_reason': cancelReason,
  });
}

Map<String, dynamic> _historyRow({
  required int id,
  required String from,
  required String to,
  int? employeeId = 7,
  String employeeName = 'Khaled Nasser',
  required String at,
}) {
  return {
    'id': id,
    'order_id': 482,
    'employee_id': employeeId,
    'employee': {
      'id': employeeId,
      'user': {
        'id': 41,
        'name': employeeName,
        'email': 'khaled@example.com',
        'phone': '0512223333',
      },
    },
    'from_status': from,
    'to_status': to,
    'note': null,
    'created_at': at,
  };
}

List<OrderStatusHistoryModel> _history(List<Map<String, dynamic>> rows) =>
    rows.map(OrderStatusHistoryModel.fromJson).toList();

void main() {
  group('بناء المراحل', () {
    test('مرحلة الإنشاء تُبنى من created_at لأن السجل لا يحويها', () {
      // سجل حجز جديد يعود فارغاً تماماً
      final stages = OrderTimeline.build(
        _order(
          status: 'pending',
          assignedAt: null,
          startedAt: null,
          completedAt: null,
        ),
        const [],
      );

      expect(stages.first.key, OrderStageKey.placed);
      expect(stages.first.at, isNotNull);
      expect(stages.first.isCurrent, isTrue);
    });

    test('الطلب المكتمل يمرّ بكل المراحل بالترتيب', () {
      final stages = OrderTimeline.build(_order(), const []);

      expect(
        stages.map((s) => s.key),
        [
          OrderStageKey.placed,
          OrderStageKey.assigned,
          OrderStageKey.inProgress,
          OrderStageKey.completed,
        ],
      );
      expect(stages.every((s) => s.at != null), isTrue);
      expect(stages.last.isCurrent, isTrue);
    });

    test('المراحل التي لم تحدث تظهر كقادمة بلا وقت', () {
      final stages = OrderTimeline.build(
        _order(status: 'assigned', startedAt: null, completedAt: null),
        const [],
      );

      final byKey = {for (final s in stages) s.key: s};
      expect(byKey[OrderStageKey.assigned]!.isCurrent, isTrue);
      expect(byKey[OrderStageKey.inProgress]!.state, OrderStageState.upcoming);
      expect(byKey[OrderStageKey.inProgress]!.at, isNull);
      expect(byKey[OrderStageKey.completed]!.state, OrderStageState.upcoming);
    });

    test('الطلب الملغى يُنهى بمرحلة إلغاء بدل الاكتمال', () {
      final stages = OrderTimeline.build(
        _order(
          status: 'cancelled',
          startedAt: null,
          completedAt: null,
          cancelledAt: '2026-08-18T08:50:00+00:00',
          cancelReason: 'غيّرت رأيي',
        ),
        const [],
      );

      expect(stages.map((s) => s.key), isNot(contains(OrderStageKey.completed)));
      expect(stages.last.key, OrderStageKey.cancelled);
      // سبب الإلغاء يأتي من الطلب لا من سجل الحالات
      expect(stages.last.detail, 'غيّرت رأيي');
    });
  });

  group('الحالة هي مصدر الحقيقة للتقدّم', () {
    test('طلب قيد التنفيذ بلا أي أوقات يظهر عند مرحلة التنفيذ لا الإنشاء', () {
      // الحالة الوحيدة المتاحة أحياناً: أوقات دورة الحياة تصل فارغة
      final stages = OrderTimeline.build(
        _order(
          status: 'in_progress',
          assignedAt: null,
          startedAt: null,
          completedAt: null,
        ),
        const [],
      );

      final byKey = {for (final s in stages) s.key: s};
      expect(byKey[OrderStageKey.placed]!.isDone, isTrue);
      expect(byKey[OrderStageKey.assigned]!.isDone, isTrue);
      expect(byKey[OrderStageKey.inProgress]!.isCurrent, isTrue);
      expect(byKey[OrderStageKey.completed]!.state, OrderStageState.upcoming);
    });

    test('الوقت الناقص لا يلغي المرحلة بل يظهرها بلا وقت', () {
      final stages = OrderTimeline.build(
        _order(status: 'in_progress', assignedAt: null, completedAt: null),
        const [],
      );

      final assigned = stages.firstWhere(
        (s) => s.key == OrderStageKey.assigned,
      );
      expect(assigned.isDone, isTrue);
      expect(assigned.at, isNull);
    });

    test('طلب مكتمل بلا أوقات يعرض كل المراحل منجزة', () {
      final stages = OrderTimeline.build(
        _order(
          status: 'completed',
          assignedAt: null,
          startedAt: null,
          completedAt: null,
        ),
        const [],
      );

      expect(stages.every((s) => s.isDone || s.isCurrent), isTrue);
      expect(stages.last.key, OrderStageKey.completed);
      expect(stages.last.isCurrent, isTrue);
    });

    test('حالة غير معروفة تُعامل كطلب جديد بدل كسر الخط الزمني', () {
      final stages = OrderTimeline.build(
        _order(status: 'something_new'),
        const [],
      );

      expect(stages.first.isCurrent, isTrue);
      expect(stages.length, 4);
    });

    test('الملغى يستدل بـ from_status لمعرفة المرحلة التي وقف عندها', () {
      final stages = OrderTimeline.build(
        _order(
          status: 'cancelled',
          assignedAt: null,
          startedAt: null,
          completedAt: null,
          cancelledAt: '2026-08-18T09:30:00+00:00',
        ),
        _history([
          _historyRow(
            id: 230,
            from: 'in_progress',
            to: 'cancelled',
            employeeId: null,
            at: '2026-08-18T09:30:00+00:00',
          ),
        ]),
      );

      final byKey = {for (final s in stages) s.key: s};
      // بلغ التنفيذ قبل الإلغاء رغم غياب الأوقات
      expect(byKey[OrderStageKey.assigned]!.isDone, isTrue);
      expect(byKey[OrderStageKey.inProgress]!.isDone, isTrue);
      expect(byKey.containsKey(OrderStageKey.completed), isFalse);
      expect(stages.last.key, OrderStageKey.cancelled);
      expect(stages.last.isCurrent, isTrue);
    });

    test('الملغى بلا سجل يستدل بالأوقات المتاحة', () {
      final stages = OrderTimeline.build(
        _order(
          status: 'cancelled',
          startedAt: null,
          completedAt: null,
          cancelledAt: '2026-08-18T08:50:00+00:00',
        ),
        const [],
      );

      final byKey = {for (final s in stages) s.key: s};
      expect(byKey[OrderStageKey.assigned]!.isDone, isTrue);
      // لم يبدأ التنفيذ: لا وقت ولا سطر في السجل
      expect(byKey[OrderStageKey.inProgress]!.state, OrderStageState.upcoming);
    });
  });

  group('من نفّذ الانتقال', () {
    test('يُقرأ اسم الفني من سجل الحالات', () {
      final stages = OrderTimeline.build(
        _order(),
        _history([
          _historyRow(
            id: 210,
            from: 'pending',
            to: 'assigned',
            at: '2026-08-18T08:40:00+00:00',
          ),
          _historyRow(
            id: 214,
            from: 'assigned',
            to: 'in_progress',
            at: '2026-08-18T09:12:33+00:00',
          ),
        ]),
      );

      final byKey = {for (final s in stages) s.key: s};
      expect(byKey[OrderStageKey.assigned]!.actorName, 'Khaled Nasser');
      expect(byKey[OrderStageKey.inProgress]!.actorName, 'Khaled Nasser');
      // مرحلة بلا سطر في السجل تبقى بلا منفّذ
      expect(byKey[OrderStageKey.completed]!.actorName, isNull);
    });

    test('إلغاء بلا employee_id يعني الزبون أو الإدارة لا فنياً', () {
      final stages = OrderTimeline.build(
        _order(
          status: 'cancelled',
          startedAt: null,
          completedAt: null,
          cancelledAt: '2026-08-18T08:50:00+00:00',
        ),
        _history([
          _historyRow(
            id: 220,
            from: 'assigned',
            to: 'cancelled',
            employeeId: null,
            at: '2026-08-18T08:50:00+00:00',
          ),
        ]),
      );

      expect(stages.last.key, OrderStageKey.cancelled);
      // كائن الموظف موجود لكنه فارغ، والاعتماد على المعرّف
      expect(stages.last.actorName, isNull);
    });

    test('الترتيب يفكّ التعادل بالمعرّف عند تساوي الثانية', () {
      // created_at بدقة الثانية، فقد يتساوى انتقالان
      final rows = _history([
        _historyRow(
          id: 219,
          from: 'in_progress',
          to: 'completed',
          employeeName: 'Second',
          at: '2026-08-18T09:00:00+00:00',
        ),
        _historyRow(
          id: 214,
          from: 'assigned',
          to: 'in_progress',
          employeeName: 'First',
          at: '2026-08-18T09:00:00+00:00',
        ),
      ]);

      final stages = OrderTimeline.build(_order(), rows);
      final byKey = {for (final s in stages) s.key: s};

      expect(byKey[OrderStageKey.inProgress]!.actorName, 'First');
      expect(byKey[OrderStageKey.completed]!.actorName, 'Second');
    });
  });

  group('المدد', () {
    test('مدة التنفيذ من البدء حتى الاكتمال', () {
      final duration = OrderTimeline.workDuration(_order());
      expect(duration!.inMinutes, 52);
    });

    test('تأخر البدء يُحسب مقابل الموعد الموعود', () {
      // الموعد 09:00 والبدء 09:12:33 ⇒ تأخّر
      final punctuality = OrderTimeline.punctuality(_order());
      expect(punctuality!.isNegative, isFalse);
      expect(punctuality.inMinutes, 12);
    });

    test('البدء قبل الموعد يعطي مدة سالبة', () {
      final punctuality = OrderTimeline.punctuality(
        _order(
          scheduledAt: '2026-08-18T09:30:00+00:00',
          startedAt: '2026-08-18T09:12:00+00:00',
        ),
      );

      expect(punctuality!.isNegative, isTrue);
      expect(punctuality.inMinutes, -18);
    });

    test('المدد الناقصة تعيد null بدل أن ترمي', () {
      final never = _order(startedAt: null, completedAt: null);

      expect(OrderTimeline.workDuration(never), isNull);
      expect(OrderTimeline.punctuality(never), isNull);
      expect(OrderTimeline.elapsedSinceStart(never), isNull);
    });

    test('الوقت المنقضي يُحسب للطلب الجاري فقط', () {
      final running = _order(status: 'in_progress', completedAt: null);
      final done = _order(status: 'completed');

      expect(OrderTimeline.elapsedSinceStart(running), isNotNull);
      expect(OrderTimeline.elapsedSinceStart(done), isNull);
    });
  });

  group('صياغة المدة', () {
    test('تصاغ بالعربية حسب العدد', () {
      expect(OrderTimeline.formatDuration(const Duration(seconds: 30)), 'أقل من دقيقة');
      expect(OrderTimeline.formatDuration(const Duration(minutes: 1)), 'دقيقة');
      expect(OrderTimeline.formatDuration(const Duration(minutes: 2)), 'دقيقتين');
      expect(OrderTimeline.formatDuration(const Duration(minutes: 52)), '52 دقيقة');
      expect(OrderTimeline.formatDuration(const Duration(hours: 1)), 'ساعة');
      expect(
        OrderTimeline.formatDuration(const Duration(hours: 2, minutes: 30)),
        'ساعتين و30 دقيقة',
      );
    });

    test('المدة السالبة تُصاغ بقيمتها المطلقة', () {
      expect(
        OrderTimeline.formatDuration(const Duration(minutes: -18)),
        '18 دقيقة',
      );
    });
  });

  group('قراءة سطر السجل', () {
    test('لا يُقرأ بريد الفني ولا هاتفه', () {
      final row = OrderStatusHistoryModel.fromJson(
        _historyRow(
          id: 210,
          from: 'pending',
          to: 'assigned',
          at: '2026-08-18T08:40:00+00:00',
        ),
      );

      // الاسم فقط متاح على الموديل — لا حقل للبريد أو الهاتف أصلاً
      expect(row.employeeName, 'Khaled Nasser');
      expect(row.isByEmployee, isTrue);
    });

    test('employee_id فارغ يعني لم ينفّذه فني', () {
      final row = OrderStatusHistoryModel.fromJson(
        _historyRow(
          id: 220,
          from: 'assigned',
          to: 'cancelled',
          employeeId: null,
          at: '2026-08-18T08:50:00+00:00',
        ),
      );

      expect(row.isByEmployee, isFalse);
    });
  });
}
