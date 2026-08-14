import 'package:car_care_plus/features/wallet_and_payments/data/models/payment_model.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/models/wallet_response_model.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/models/wallet_transaction_model.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/repos/wallet_payment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallet_payment_state.dart';

class WalletPaymentCubit extends Cubit<WalletPaymentState> {
  final WalletPaymentRepo _repo;

  WalletPaymentCubit(this._repo) : super(WalletPaymentInitialState());

  /// جلب كافة البيانات الأساسية (المحفظة، المدفوعات، المعاملات)
  Future<void> fetchWalletAndPaymentData({int? customerId}) async {
    emit(WalletPaymentLoadingState());
    try {
      // تنفيذ الطلبات الثلاثة بالتوازي لسرعة الأداء
      final results = await Future.wait([
        _repo.getMyWallet(),
        _repo.getPayments(),
        _repo.getWalletTransactions(customerId: customerId),
      ]);

      final walletData = results[0] as WalletData;
      final paymentsList = results[1] as List<PaymentItemModel>;
      final transactionsList = results[2] as List<WalletTransactionItemModel>;

      emit(WalletPaymentSuccessState(
        wallet: walletData,
        payments: paymentsList,
        transactions: transactionsList,
      ));
    } catch (e) {
      emit(WalletPaymentErrorState(e.toString()));
    }
  }

  /// جلب تفاصيل عملية دفع محددة
  Future<void> fetchPaymentDetail(int paymentId) async {
    emit(PaymentDetailLoadingState());
    try {
      final payment = await _repo.getPaymentDetail(paymentId);
      emit(PaymentDetailSuccessState(payment));
    } catch (e) {
      emit(WalletPaymentErrorState(e.toString()));
    }
  }
}