import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/features/wallet_and_payments/data/repos/wallet_payment_repo.dart';
import 'wallet_payment_state.dart';

class WalletPaymentCubit extends Cubit<WalletPaymentState> {
  final WalletPaymentRepo _repo;

  WalletPaymentCubit(this._repo) : super(WalletPaymentInitialState());

  static const int _perPage = 20;

  bool _isFetching = false;

  void _safeEmit(WalletPaymentState state) {
    if (!isClosed) emit(state);
  }

  /// جلب الرصيد وأول صفحة من سجل الحركات معاً.
  ///
  /// يجب استدعاؤها عند كل عودة للشاشة: الرصيد يتغيّر كأثر جانبي لتأكيد حجز أو
  /// إلغائه أو شراء باقة، ولا يوجد أي دفع أو اشتراك لحظي من الباك اند.
  Future<void> fetchWalletAndPaymentData({int? customerId}) async {
    if (_isFetching) return;
    _isFetching = true;

    _safeEmit(WalletPaymentLoadingState());
    try {
      // ننفّذ الطلبين بالتوازي مع الحفاظ على أنواعهما
      final walletFuture = _repo.getMyWallet();
      final ledgerFuture = _repo.getWalletTransactions(
        customerId: customerId,
        perPage: _perPage,
      );

      final wallet = await walletFuture;
      final ledger = await ledgerFuture;

      _safeEmit(
        WalletPaymentSuccessState(
          wallet: wallet,
          transactions: ledger.data,
          pagination: ledger.pagination,
        ),
      );
    } catch (error) {
      _safeEmit(WalletPaymentErrorState(error.toString()));
    } finally {
      _isFetching = false;
    }
  }

  /// جلب الرصيد وحده بدون سجل الحركات.
  ///
  /// تستخدمه بطاقة الرصيد في الصفحة الرئيسية: هي لا تعرض أي حركة، فلا داعي
  /// لإطلاق طلب السجل المرقّم مع كل فتح للتطبيق.
  Future<void> fetchWalletBalance() async {
    if (_isFetching) return;
    _isFetching = true;

    _safeEmit(WalletPaymentLoadingState());
    try {
      final wallet = await _repo.getMyWallet();
      _safeEmit(
        WalletPaymentSuccessState(wallet: wallet, transactions: const []),
      );
    } catch (error) {
      _safeEmit(WalletPaymentErrorState(error.toString()));
    } finally {
      _isFetching = false;
    }
  }

  /// تحميل الصفحة التالية من السجل عند الوصول لنهاية القائمة
  Future<void> loadMoreTransactions({int? customerId}) async {
    final current = state;
    if (current is! WalletPaymentSuccessState) return;
    if (_isFetching || current.isLoadingMore || !current.hasMore) return;

    _isFetching = true;
    _safeEmit(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = (current.pagination?.currentPage ?? 1) + 1;
      final ledger = await _repo.getWalletTransactions(
        customerId: customerId,
        page: nextPage,
        perPage: _perPage,
      );

      // ندمج بالاعتماد على المعرّف حتى لا تتكرر الصفوف إذا تغيّر السجل بين الصفحات
      final existingIds = current.transactions.map((e) => e.id).toSet();
      final merged = [
        ...current.transactions,
        ...ledger.data.where((e) => !existingIds.contains(e.id)),
      ];

      _safeEmit(
        current.copyWith(
          transactions: merged,
          pagination: ledger.pagination,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      // فشل صفحة إضافية لا يجب أن يمسح ما هو معروض
      _safeEmit(current.copyWith(isLoadingMore: false));
    } finally {
      _isFetching = false;
    }
  }
}
