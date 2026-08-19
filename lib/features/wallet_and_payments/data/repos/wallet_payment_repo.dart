import 'package:car_care_plus/core/networking/api_constants.dart';
import 'package:car_care_plus/core/networking/api_service.dart';
import 'package:car_care_plus/features/orders/data/booking_model.dart';
import '../models/wallet_response_model.dart';
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

  /// 2. جلب قائمة جميع الطلبات/المدفوعات الخاصة بالعميل (GET /api/payments)
  Future<List<BookingModel>> getPayments() async {
    final response = await _apiService.get(
      endpoint: ApiConstants.payments,
    );
    
    // تحويل القائمة القادمة من API إلى BookingModel
    final List listData = response.data['data'] ?? response.data;
    return listData.map((item) => BookingModel.fromJson(item)).toList();
  }

  /// 3. جلب تفاصيل عملية دفع/طلب محددة (GET /api/payments/{id})
  Future<BookingModel> getPaymentDetail(int paymentId) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.showPayment(paymentId),
    );
    
    final data = response.data['data'] ?? response.data;
    return BookingModel.fromJson(data);
  }

  /// 4. جلب سجل معاملات المحفظة (GET /api/wallet-transactions/{customer_id?})
  ///
  /// مرقّم ومرتّب من الأحدث للأقدم. بيانات الترقيم تصل في مفتاح `pagination`
  /// بجانب `data` لا داخله.
  /// ملاحظة: عند استدعائه من حساب زبون يعيد سجلّه هو دائماً، ويُتجاهل
  /// `customerId` — التمرير مفيد فقط لحسابات الإدارة.
  Future<WalletTransactionResponseModel> getWalletTransactions({
    int? customerId,
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.walletTransactions(customerId: customerId),
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return WalletTransactionResponseModel.fromJson(response.data);
  }
}