import 'package:car_care_plus/features/wallet_and_payments/data/models/payment_model.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/models/wallet_response_model.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/models/wallet_transaction_model.dart';



abstract class WalletPaymentState {}

/// الحالة الأولية
class WalletPaymentInitialState extends WalletPaymentState {}

/// حالة التحميل
class WalletPaymentLoadingState extends WalletPaymentState {}

/// حالة النجاح عند جلب المحفظة والمدفوعات
class WalletPaymentSuccessState extends WalletPaymentState {
  final WalletData wallet;
  final List<PaymentItemModel> payments;
  final List<WalletTransactionItemModel> transactions;

  WalletPaymentSuccessState({
    required this.wallet,
    required this.payments,
    required this.transactions,
  });
}

/// حالة جلب تفاصيل دفع محددة
class PaymentDetailLoadingState extends WalletPaymentState {}

class PaymentDetailSuccessState extends WalletPaymentState {
  final PaymentItemModel paymentDetail;

  PaymentDetailSuccessState(this.paymentDetail);
}

/// حالة الخطأ
class WalletPaymentErrorState extends WalletPaymentState {
  final String message;

  WalletPaymentErrorState(this.message);
}