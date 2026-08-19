import 'package:car_care_plus/features/wallet_and_payments/data/models/wallet_transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _row({
  String type = 'debit',
  String reason = 'order_payment',
  dynamic amount = '210.00',
  String? note,
  dynamic balanceBefore = '1460.00',
  dynamic balanceAfter = '1250.00',
}) {
  return {
    'id': 902,
    'wallet_id': 12,
    'user_id': 17,
    'type': type,
    'reason': reason,
    'amount': amount,
    'balance_before': balanceBefore,
    'balance_after': balanceAfter,
    'note': note,
    'created_at': '2026-08-17T09:12:33+00:00',
  };
}

void main() {
  group('تحويل المبالغ النصية', () {
    test('المبالغ تصل كنصوص وتُقرأ كأرقام', () {
      final model = WalletTransactionItemModel.fromJson(_row());

      expect(model.amount, 210.0);
      expect(model.balanceBefore, 1460.0);
      expect(model.balanceAfter, 1250.0);
    });

    test('يقبل المبالغ الرقمية أيضاً', () {
      final model = WalletTransactionItemModel.fromJson(
        _row(amount: 75.5, balanceBefore: 100, balanceAfter: 24.5),
      );

      expect(model.amount, 75.5);
      expect(model.balanceAfter, 24.5);
    });

    test('المبالغ المفقودة أو التالفة لا ترمي استثناء', () {
      final model = WalletTransactionItemModel.fromJson(
        _row(amount: null, balanceBefore: 'abc', balanceAfter: null),
      );

      expect(model.amount, 0.0);
      expect(model.balanceBefore, isNull);
      expect(model.balanceAfter, isNull);
    });
  });

  group('اتجاه الحركة', () {
    test('الاتجاه يأتي من type لا من إشارة المبلغ', () {
      final debit = WalletTransactionItemModel.fromJson(_row(type: 'debit'));
      final credit = WalletTransactionItemModel.fromJson(
        _row(type: 'credit', reason: 'refund'),
      );

      // المبلغ موجب دائماً في الحالتين
      expect(debit.amount, isPositive);
      expect(credit.amount, isPositive);

      expect(debit.isCredit, isFalse);
      expect(debit.signedAmount, -210.0);
      expect(credit.isCredit, isTrue);
      expect(credit.signedAmount, 210.0);
    });
  });

  group('عناوين الحركات', () {
    test('دفع حجز يُميَّز عن شراء باقة من نص الملاحظة', () {
      // الاثنان يصلان بنفس السبب order_payment
      final booking = WalletTransactionItemModel.fromJson(
        _row(note: 'Booking #482'),
      );
      final package = WalletTransactionItemModel.fromJson(
        _row(note: 'Package purchase #7'),
      );

      expect(booking.isPackagePurchase, isFalse);
      expect(booking.title, 'دفع حجز');
      expect(package.isPackagePurchase, isTrue);
      expect(package.title, 'شراء باقة');
    });

    test('الاسترجاع وتعديلات الدعم لها عناوين خاصة', () {
      final refund = WalletTransactionItemModel.fromJson(
        _row(type: 'credit', reason: 'refund'),
      );
      final creditAdjustment = WalletTransactionItemModel.fromJson(
        _row(type: 'credit', reason: 'adjustment'),
      );
      final debitAdjustment = WalletTransactionItemModel.fromJson(
        _row(type: 'debit', reason: 'adjustment'),
      );

      expect(refund.title, 'استرجاع مبلغ');
      expect(creditAdjustment.title, 'إضافة رصيد من الدعم');
      expect(debitAdjustment.title, 'خصم من الدعم');
    });

    test('أي سبب جديد يحصل على عنوان افتراضي بدل أن يكسر الواجهة', () {
      final unknown = WalletTransactionItemModel.fromJson(
        _row(type: 'credit', reason: 'something_new'),
      );

      expect(unknown.title, 'إيداع في المحفظة');
    });

    test('ملاحظة فارغة لا تجعل الحركة شراء باقة', () {
      final model = WalletTransactionItemModel.fromJson(_row(note: null));
      expect(model.isPackagePurchase, isFalse);
      expect(model.title, 'دفع حجز');
    });
  });

  group('المغلّف والترقيم', () {
    test('بيانات الترقيم تُقرأ من المفتاح المجاور لا من داخل data', () {
      final response = WalletTransactionResponseModel.fromJson({
        'status': 1,
        'data': [_row(), _row(type: 'credit', reason: 'refund')],
        'message': 'Wallet transactions retrieved successfully',
        'pagination': {
          'current_page': 1,
          'per_page': 20,
          'total': 42,
          'last_page': 3,
        },
      });

      expect(response.data, hasLength(2));
      expect(response.pagination, isNotNull);
      expect(response.pagination!.total, 42);
      expect(response.pagination!.hasNextPage, isTrue);
    });

    test('الصفحة الأخيرة لا تطلب المزيد', () {
      final response = WalletTransactionResponseModel.fromJson({
        'status': 1,
        'data': [],
        'pagination': {
          'current_page': 3,
          'per_page': 20,
          'total': 42,
          'last_page': 3,
        },
      });

      expect(response.pagination!.hasNextPage, isFalse);
    });

    test('غياب الترقيم أو السجل الفارغ لا يرمي', () {
      final response = WalletTransactionResponseModel.fromJson({
        'status': 1,
        'data': [],
      });

      expect(response.data, isEmpty);
      expect(response.pagination, isNull);
    });
  });
}
