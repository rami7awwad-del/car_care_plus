import 'package:car_care_plus/features/booking/data/models/booking_quote_response_model.dart';
import 'package:car_care_plus/features/packages/data/models/user_package_model.dart';
import 'package:car_care_plus/features/packages/logic/packages_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

String _isoDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

void main() {
  group('الاشتراك المتاح في تدفّق الحجز', () {
    test('id هو معرّف الاشتراك لا معرّف الخطة', () {
      // available_packages عناصرها UserPackageResource:
      // id = user_package، وpackage.id = الخطة
      final available = AvailablePackage.fromJson({
        'id': 5,
        'remaining_count': 4,
        'end_date': '2026-09-17',
        'package': {'id': 3, 'name': 'Monthly Wash'},
      });

      expect(available.id, 5);
      expect(available.name, 'Monthly Wash');
      expect(available.remainingCount, 4);
      expect(available.endDate, '2026-09-17');
    });

    test('الاستخدامات المتبقية تُقارن بعدد سيارات الحجز', () {
      final available = AvailablePackage.fromJson({
        'id': 5,
        'remaining_count': 2,
        'package': {'name': 'Monthly Wash'},
      });

      expect(available.coversCars(1), isTrue);
      expect(available.coversCars(2), isTrue);
      // ثلاث سيارات تحتاج ثلاثة استخدامات
      expect(available.coversCars(3), isFalse);
    });

    test('الحقول الناقصة لا ترمي', () {
      final available = AvailablePackage.fromJson({'id': 7});

      expect(available.id, 7);
      expect(available.remainingCount, 0);
      expect(available.endDate, isNull);
      expect(available.coversCars(1), isFalse);
    });
  });

  group('انتهاء الاشتراك يُحسب من end_date', () {
    UserPackageModel subscription(String? endDate, {String status = 'active'}) {
      return UserPackageModel.fromJson({
        'id': 5,
        'user_id': 17,
        'package_id': 3,
        'start_date': '2026-08-01',
        'end_date': endDate,
        'remaining_count': 4,
        'status': status,
      });
    }

    test('تاريخ اليوم نفسه ما زال صالحاً', () {
      // لا يجوز اعتباره منتهياً منذ منتصف الليل — التواريخ بلا وقت
      final today = subscription(_isoDate(DateTime.now()));
      expect(today.isExpired, isFalse);
    });

    test('تاريخ الأمس منتهٍ', () {
      final yesterday = subscription(
        _isoDate(DateTime.now().subtract(const Duration(days: 1))),
      );
      expect(yesterday.isExpired, isTrue);
    });

    test('تاريخ مستقبلي غير منتهٍ', () {
      final future = subscription(
        _isoDate(DateTime.now().add(const Duration(days: 20))),
      );
      expect(future.isExpired, isFalse);
      expect(future.daysRemaining, greaterThan(0));
    });

    test('بلا تاريخ انتهاء لا يُعتبر منتهياً', () {
      expect(subscription(null).isExpired, isFalse);
      expect(subscription(null).daysRemaining, isNull);
    });

    test('الحالة active مع تاريخ ماضٍ تبقى منتهية', () {
      // الباك اند لا يحوّل status إلى expired تلقائياً
      final stale = subscription('2020-01-01', status: 'active');
      expect(stale.status, 'active');
      expect(stale.isExpired, isTrue);
    });
  });
}
