import 'package:car_care_plus/features/packages/data/models/package_model.dart';
import 'package:car_care_plus/features/packages/data/models/user_package_model.dart';
import 'package:car_care_plus/features/packages/logic/packages_state.dart';
import 'package:flutter_test/flutter_test.dart';

PackageModel _package({int id = 5, String name = 'الباقة الفضية', bool isActive = true}) {
  return PackageModel.fromJson({
    'id': id,
    'name': name,
    'description': 'وصف',
    'type': 'wash',
    'is_company_package': false,
    'price': '250.00',
    'discount_pct': '10',
    'services_count': 8,
    'valid_days': 30,
    'is_active': isActive,
  });
}

UserPackageModel _subscription({
  int packageId = 5,
  String status = 'active',
  String name = 'الباقة الفضية',
}) {
  return UserPackageModel.fromJson({
    'id': 90,
    'user_id': 17,
    'package_id': packageId,
    'start_date': '2026-08-01',
    'end_date': '2026-09-01',
    'remaining_count': 6,
    'status': status,
    'package': _package(id: packageId, name: name).toJson(),
  });
}

void main() {
  group('منع الاشتراك المزدوج', () {
    test('بلا اشتراك نشط يُسمح بالاشتراك', () {
      const state = PackagesState(status: PackagesStatus.success);

      expect(state.hasActiveSubscription, isFalse);
      expect(state.canSubscribeTo(_package()), isTrue);
      expect(state.blockedReasonFor(_package()), isNull);
    });

    test('مع اشتراك نشط تُمنع كل الباقات الأخرى', () {
      final state = PackagesState(
        status: PackagesStatus.success,
        activeUserPackage: _subscription(packageId: 5),
      );

      final other = _package(id: 9, name: 'الباقة الذهبية');
      expect(state.hasActiveSubscription, isTrue);
      expect(state.canSubscribeTo(other), isFalse);
      expect(state.blockedReasonFor(other), contains('الباقة الفضية'));
    });

    test('باقة المستخدم نفسها تُعرَّف كاشتراكه الحالي', () {
      final state = PackagesState(
        status: PackagesStatus.success,
        activeUserPackage: _subscription(packageId: 5),
      );

      expect(state.isCurrentSubscription(5), isTrue);
      expect(state.isCurrentSubscription(9), isFalse);
      // لا يُعاد الاشتراك بنفس الباقة أيضاً
      expect(state.canSubscribeTo(_package(id: 5)), isFalse);
      expect(state.blockedReasonFor(_package(id: 5)), 'أنت مشترك في هذه الباقة');
    });

    test('الباقة غير المتاحة تُمنع حتى بلا اشتراك نشط', () {
      const state = PackagesState(status: PackagesStatus.success);
      final inactive = _package(id: 12, isActive: false);

      expect(state.canSubscribeTo(inactive), isFalse);
      expect(state.blockedReasonFor(inactive), 'هذه الباقة غير متاحة حالياً');
    });

    test('اشتراك بلا اسم باقة يعطي رسالة عامة بدل رسالة ناقصة', () {
      final subscription = UserPackageModel.fromJson({
        'id': 90,
        'user_id': 17,
        'package_id': 5,
        'remaining_count': 3,
        'status': 'active',
      });
      final state = PackagesState(
        status: PackagesStatus.success,
        activeUserPackage: subscription,
      );

      expect(
        state.blockedReasonFor(_package(id: 9)),
        'لديك باقة نشطة، لا يمكن الاشتراك بأخرى قبل انتهائها',
      );
    });
  });

  group('كفاية رصيد المحفظة', () {
    test('الرصيد غير الكافي يمنع الشراء ويوضّح النقص', () {
      // السعر 250 والرصيد 180 ⇒ ينقص 70
      const state = PackagesState(
        status: PackagesStatus.success,
        walletBalance: 180,
      );

      expect(state.canAfford(_package()), isFalse);
      expect(state.shortfallFor(_package()), 70);
      expect(state.canSubscribeTo(_package()), isFalse);
      expect(state.blockedReasonFor(_package()), contains('70'));
    });

    test('الرصيد المساوي للسعر يكفي', () {
      const state = PackagesState(
        status: PackagesStatus.success,
        walletBalance: 250,
      );

      expect(state.canAfford(_package()), isTrue);
      expect(state.shortfallFor(_package()), 0);
      expect(state.canSubscribeTo(_package()), isTrue);
    });

    test('تعذّر قراءة الرصيد لا يمنع الشراء', () {
      // walletBalance = null يعني أن الطلب فشل، فلا نمنع بلا سبب
      const state = PackagesState(status: PackagesStatus.success);

      expect(state.canAfford(_package()), isTrue);
      expect(state.canSubscribeTo(_package()), isTrue);
    });

    test('السعر النصي يُحوَّل إلى رقم قبل المقارنة', () {
      const state = PackagesState(status: PackagesStatus.success);
      // price تصل كنص "250.00" من الباك اند
      expect(state.priceOf(_package()), 250.0);
    });
  });

  group('حالة الاشتراك', () {
    test('isSubscribing يعتمد على معرّف الباقة الجاري تنفيذها', () {
      const idle = PackagesState(status: PackagesStatus.success);
      const busy = PackagesState(
        status: PackagesStatus.success,
        subscribingPackageId: 5,
      );

      expect(idle.isSubscribing, isFalse);
      expect(busy.isSubscribing, isTrue);
      expect(busy.subscribingPackageId, 5);
    });

    test('copyWith يمسح الاشتراك النشط عند الطلب صراحة', () {
      final state = PackagesState(
        status: PackagesStatus.success,
        activeUserPackage: _subscription(),
      );

      // بدون العلم الصريح يبقى الاشتراك القديم بسبب معامل ??
      expect(state.copyWith().hasActiveSubscription, isTrue);
      expect(
        state.copyWith(clearActivePackage: true).hasActiveSubscription,
        isFalse,
      );
    });

    test('الحالة تحتفظ بالباقات أثناء تحميل التفاصيل', () {
      // هذا ما كان يكسر المنع سابقاً: تحميل التفاصيل كان يمسح كل شيء
      final state = PackagesState(
        status: PackagesStatus.success,
        availablePackages: [_package(), _package(id: 9)],
        activeUserPackage: _subscription(),
      ).copyWith(isLoadingDetails: true);

      expect(state.availablePackages, hasLength(2));
      expect(state.hasActiveSubscription, isTrue);
      expect(state.isLoadingDetails, isTrue);
    });
  });
}
