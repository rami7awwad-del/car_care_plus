import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import '../models/wallet_response_model.dart';
import '../models/payment_model.dart';
import '../models/wallet_transaction_model.dart';

class WalletPaymentRepo {
  final ApiService _apiService;

  WalletPaymentRepo(this._apiService);

  /// 1. جلب بيانات المحفظة الخاصة بالعميل (GET /api/wallets/my)
  Future<WalletData> getMyWallet() async {
    final response = await _apiService.get(
      endpoint: ApiConstants.myWallet,
    );
    final walletResponse = WalletResponseModel.fromJson(response.data);
    return walletResponse.data;
  }

  /// 2. جلب قائمة جميع المدفوعات الخاصة بالعميل (GET /api/payments)
  Future<List<PaymentItemModel>> getPayments() async {
    final response = await _apiService.get(
      endpoint: ApiConstants.payments,
    );
    final paymentResponse = PaymentResponseModel.fromJson(response.data);
    return paymentResponse.data;
  }

  /// 3. جلب تفاصيل عملية دفع محددة (GET /api/payments/{id})
  Future<PaymentItemModel> getPaymentDetail(int paymentId) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.showPayment(paymentId),
    );
    final singlePaymentResponse = SinglePaymentResponseModel.fromJson(response.data);
    return singlePaymentResponse.data;
  }

  /// 4. جلب سجل معاملات المحفظة (GET /api/wallet-transactions/{customer_id?})
  Future<List<WalletTransactionItemModel>> getWalletTransactions({int? customerId}) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.walletTransactions(customerId: customerId),
    );
    final transactionResponse = WalletTransactionResponseModel.fromJson(response.data);
    return transactionResponse.data;
  }
}