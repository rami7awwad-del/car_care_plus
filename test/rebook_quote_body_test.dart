import 'package:car_care_plus/features/orders/data/models/rebook_prefill_model.dart';
import 'package:flutter_test/flutter_test.dart';

RebookPrefillModel _prefillWith(Map<String, dynamic> formDefaults) {
  return RebookPrefillModel.fromJson({
    'data': {'form_defaults': formDefaults},
  });
}

void main() {
  final baseDefaults = <String, dynamic>{
    'car_ids': [9],
    'service_id': 12,
    'booking_type': false,
    'scheduled_at': null,
    'is_vip': false,
    'branch_id': 3,
    'notes': 'اتصل عند الوصول',
    'payment_method': 'wallet',
    'user_package_id': null,
    'sub_service_ids': [4, 7],
    'materials': [
      {'material_id': 22, 'quantity': 2},
    ],
  };

  group('buildQuoteBody', () {
    test('لا يرسل service_id لأن نقطة النهاية لا تقبله', () {
      final body = _prefillWith(baseDefaults).buildQuoteBody(
        isImmediate: false,
        scheduledAt: DateTime(2026, 9, 1, 10, 30),
        paymentMethod: 'cash',
        isVip: false,
        notes: '',
      );

      expect(body.containsKey('service_id'), isFalse);
    });

    test('الحجز الفوري لا يرسل scheduled_at إطلاقاً', () {
      // إرسال موعد مع حجز فوري يعطي 422 من التحقق في الباك اند
      final body = _prefillWith(baseDefaults).buildQuoteBody(
        isImmediate: true,
        scheduledAt: DateTime(2026, 9, 1, 10, 30),
        paymentMethod: 'cash',
        isVip: false,
        notes: '',
      );

      expect(body['booking_type'], isTrue);
      expect(body.containsKey('scheduled_at'), isFalse);
    });

    test('الحجز المجدول يرسل الموعد بصيغة يقبلها السيرفر', () {
      final body = _prefillWith(baseDefaults).buildQuoteBody(
        isImmediate: false,
        scheduledAt: DateTime(2026, 9, 1, 10, 30),
        paymentMethod: 'cash',
        isVip: false,
        notes: '',
      );

      expect(body['booking_type'], isFalse);
      expect(body['scheduled_at'], '2026-09-01 10:30:00');
    });

    test('تمرّ الحقول غير المعروضة في الواجهة كما هي', () {
      final body = _prefillWith(baseDefaults).buildQuoteBody(
        isImmediate: false,
        scheduledAt: DateTime(2026, 9, 1, 10, 30),
        paymentMethod: 'cash',
        isVip: false,
        notes: '',
      );

      expect(body['car_ids'], [9]);
      expect(body['branch_id'], 3);
      expect(body['sub_service_ids'], [4, 7]);
      expect(body['materials'], [
        {'material_id': 22, 'quantity': 2},
      ]);
    });

    test('user_package_id يُرسل فقط مع الدفع بالباقة', () {
      final prefill = _prefillWith(baseDefaults);

      final withoutPackage = prefill.buildQuoteBody(
        isImmediate: true,
        scheduledAt: null,
        paymentMethod: 'cash',
        isVip: false,
        notes: '',
        userPackageId: 5,
      );
      expect(withoutPackage.containsKey('user_package_id'), isFalse);

      final withPackage = prefill.buildQuoteBody(
        isImmediate: true,
        scheduledAt: null,
        paymentMethod: 'package',
        isVip: false,
        notes: '',
        userPackageId: 5,
      );
      expect(withPackage['user_package_id'], 5);
    });

    test('باقة الطلب القديم لا تُرسل تلقائياً', () {
      // الباقة الأصلية غالباً مستهلكة، وإرسالها يفشل التسعير
      final prefill = _prefillWith({...baseDefaults, 'user_package_id': 77});

      final body = prefill.buildQuoteBody(
        isImmediate: true,
        scheduledAt: null,
        paymentMethod: 'package',
        isVip: false,
        notes: '',
      );

      expect(body.containsKey('user_package_id'), isFalse);
    });

    test('الملاحظات الفارغة تُحذف بدل إرسال نص فارغ', () {
      final body = _prefillWith(baseDefaults).buildQuoteBody(
        isImmediate: true,
        scheduledAt: null,
        paymentMethod: 'cash',
        isVip: false,
        notes: '   ',
      );

      expect(body.containsKey('notes'), isFalse);
    });

    test('لا يعدّل النموذج الأصلي بين الاستدعاءات', () {
      final prefill = _prefillWith(baseDefaults);

      prefill.buildQuoteBody(
        isImmediate: true,
        scheduledAt: null,
        paymentMethod: 'cash',
        isVip: true,
        notes: 'أول',
      );
      final second = prefill.buildQuoteBody(
        isImmediate: false,
        scheduledAt: DateTime(2026, 9, 1, 8, 5),
        paymentMethod: 'wallet',
        isVip: false,
        notes: '',
      );

      // service_id ما زال موجوداً في النموذج الأصلي رغم حذفه من الجسم المُرسل
      expect(prefill.formDefaults['service_id'], 12);
      expect(second['is_vip'], isFalse);
      expect(second['scheduled_at'], '2026-09-01 08:05:00');
    });
  });

  group('المفاتيح الشرطية', () {
    test('تُكتشف حسب وجود المفتاح لا قيمته', () {
      final maintenance = _prefillWith({...baseDefaults, 'workshop_id': null});
      expect(maintenance.isMaintenance, isTrue);
      expect(maintenance.isTowing, isFalse);
      expect(maintenance.isRoadAssistance, isFalse);

      final plain = _prefillWith(baseDefaults);
      expect(plain.isMaintenance, isFalse);
    });
  });
}
