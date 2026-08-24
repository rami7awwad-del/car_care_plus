import 'package:car_care_plus/features/notifications/data/models/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationModel.fromJson', () {
    test('يقرأ الإشعار كاملاً مع الحقول الاختيارية', () {
      final model = NotificationModel.fromJson({
        'id': 128,
        'title': 'تم تأكيد حجزك',
        'body': 'تم تأكيد الطلب رقم #482',
        'type': 'success',
        'reference_type': 'order',
        'reference_id': 482,
        'is_read': false,
        'read_at': null,
        'sent_via': ['in_app', 'mail'],
        'created_at': '2026-08-17 09:12:33',
      });

      expect(model.id, 128);
      expect(model.type, NotificationType.success);
      expect(model.referenceType, NotificationReferenceTypes.order);
      expect(model.referenceId, 482);
      expect(model.isRead, isFalse);
      expect(model.readAt, isNull);
      expect(model.sentVia, ['in_app', 'mail']);
      expect(model.hasReference, isTrue);
    });

    test('أي نوع غير معروف يُعامل كـ info بدل أن يرمي خطأ', () {
      final model = NotificationModel.fromJson({
        'id': 1,
        'title': 't',
        'body': 'b',
        'type': 'something_new',
        'is_read': true,
      });

      expect(model.type, NotificationType.info);
      expect(model.hasReference, isFalse);
    });

    test('created_at الخام يُعامل كـ UTC وليس توقيتاً محلياً', () {
      // الباك اند يرسل created_at بصيغة "Y-m-d H:i:s" بتوقيت UTC بدون منطقة
      final parsed = NotificationModel.parseServerDate('2026-08-17 09:12:33');

      expect(parsed, isNotNull);
      expect(
        parsed!.toUtc(),
        DateTime.utc(2026, 8, 17, 9, 12, 33),
      );
      expect(parsed.isUtc, isFalse, reason: 'يجب تحويله للتوقيت المحلي للعرض');
    });

    test('read_at بصيغة ISO مع Z يُقرأ بنفس اللحظة', () {
      final parsed =
          NotificationModel.parseServerDate('2026-08-17T12:00:00.000000Z');

      expect(parsed!.toUtc(), DateTime.utc(2026, 8, 17, 12, 0, 0));
    });

    test('الصيغتان تعطيان نفس النتيجة لنفس اللحظة', () {
      final raw = NotificationModel.parseServerDate('2026-08-17 12:00:00');
      final iso =
          NotificationModel.parseServerDate('2026-08-17T12:00:00.000000Z');

      expect(raw, iso);
    });

    test('التواريخ الفارغة أو التالفة تعيد null بدل أن ترمي', () {
      expect(NotificationModel.parseServerDate(null), isNull);
      expect(NotificationModel.parseServerDate(''), isNull);
      expect(NotificationModel.parseServerDate('not-a-date'), isNull);
    });
  });

  group('NotificationsPagination', () {
    test('hasNextPage يعتمد على مقارنة الصفحة الحالية بالأخيرة', () {
      final first = NotificationsPagination.fromJson({
        'current_page': 1,
        'per_page': 20,
        'total': 43,
        'last_page': 3,
      });
      expect(first.hasNextPage, isTrue);

      final last = NotificationsPagination.fromJson({
        'current_page': 3,
        'per_page': 20,
        'total': 43,
        'last_page': 3,
      });
      expect(last.hasNextPage, isFalse);
    });
  });
}
