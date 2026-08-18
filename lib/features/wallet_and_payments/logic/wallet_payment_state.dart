import 'package:car_care_plus/features/orders/data/booking_model.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/models/wallet_response_model.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/models/wallet_transaction_model.dart';

abstract class WalletPaymentState {}

class WalletPaymentInitialState extends WalletPaymentState {}

class WalletPaymentLoadingState extends WalletPaymentState {}

class WalletPaymentSuccessState extends WalletPaymentState {
  final WalletData wallet;
  final List<WalletTransactionItemModel> transactions;
  final WalletPagination? pagination;

  /// صفحة إضافية من السجل قيد التحميل
  final bool isLoadingMore;

  WalletPaymentSuccessState({
    required this.wallet,
    required this.transactions,
    this.pagination,
    this.isLoadingMore = false,
  });

  bool get hasMore => pagination?.hasNextPage ?? false;

  WalletPaymentSuccessState copyWith({
    WalletData? wallet,
    List<WalletTransactionItemModel>? transactions,
    WalletPagination? pagination,
    bool? isLoadingMore,
  }) {
    return WalletPaymentSuccessState(
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PaymentDetailLoadingState extends WalletPaymentState {}

class PaymentDetailSuccessState extends WalletPaymentState {
  final BookingModel paymentDetail;

  PaymentDetailSuccessState(this.paymentDetail);
}

class WalletPaymentErrorState extends WalletPaymentState {
  final String message;

  WalletPaymentErrorState(this.message);
}
