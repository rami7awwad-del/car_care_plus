/// المبالغ تصل من الباك اند كنصوص (decimal:2) وليست أرقاماً،
/// لذلك نحوّلها هنا مرة واحدة بدل التعامل معها كنصوص في الواجهة.
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

double? _toDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

/// أسباب حركة الرصيد كما يرسلها الباك اند.
/// `topup` معرّف في الـ enum لكنه غير مستخدم اليوم — لا شيء في الباك اند يكتبه.
class WalletTransactionReasons {
  static const String orderPayment = 'order_payment';
  static const String refund = 'refund';
  static const String adjustment = 'adjustment';
  static const String topup = 'topup';
}

class WalletTransactionResponseModel {
  final int status;
  final String message;
  final List<WalletTransactionItemModel> data;
  final WalletPagination? pagination;

  WalletTransactionResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory WalletTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    // بيانات الترقيم تصل في مفتاح pagination بجانب data وليس داخله
    final rawPagination = json['pagination'];

    return WalletTransactionResponseModel(
      status: _toInt(json['status']),
      message: json['message']?.toString() ?? '',
      data: rawList is List
          ? rawList
                .whereType<Map>()
                .map(
                  (e) => WalletTransactionItemModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
          : const [],
      pagination: rawPagination is Map
          ? WalletPagination.fromJson(Map<String, dynamic>.from(rawPagination))
          : null,
    );
  }
}

class WalletPagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  const WalletPagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory WalletPagination.fromJson(Map<String, dynamic> json) {
    return WalletPagination(
      currentPage: _toInt(json['current_page']),
      perPage: _toInt(json['per_page']),
      total: _toInt(json['total']),
      lastPage: _toInt(json['last_page']),
    );
  }

  bool get hasNextPage => currentPage < lastPage;
}

class WalletTransactionItemModel {
  final int id;
  final int walletId;
  final int userId;

  /// `credit` = دخول رصيد، `debit` = خروج رصيد
  final String type;

  /// `order_payment` | `refund` | `adjustment` | `topup`
  final String reason;

  /// دائماً موجب — الاتجاه يأتي من `type` وليس من إشارة المبلغ
  final double amount;

  final double? balanceBefore;
  final double? balanceAfter;

  /// نص حر من الباك اند وقد يكون متعدد الأسطر
  final String? note;

  final DateTime? createdAt;

  const WalletTransactionItemModel({
    required this.id,
    required this.walletId,
    required this.userId,
    required this.type,
    required this.reason,
    required this.amount,
    this.balanceBefore,
    this.balanceAfter,
    this.note,
    this.createdAt,
  });

  factory WalletTransactionItemModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['created_at']?.toString();

    return WalletTransactionItemModel(
      id: _toInt(json['id']),
      walletId: _toInt(json['wallet_id']),
      userId: _toInt(json['user_id']),
      type: json['type']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      amount: _toDouble(json['amount']),
      balanceBefore: _toDoubleOrNull(json['balance_before']),
      balanceAfter: _toDoubleOrNull(json['balance_after']),
      note: json['note']?.toString(),
      // تواريخ هذه النقطة ISO-8601 صحيحة، على عكس created_at في الإشعارات
      createdAt: rawDate == null ? null : DateTime.tryParse(rawDate)?.toLocal(),
    );
  }

  bool get isCredit => type.trim().toLowerCase() == 'credit';

  /// المبلغ بإشارته للعرض والحسابات
  double get signedAmount => isCredit ? amount : -amount;

  /// شراء الباقة يُسجَّل بنفس سبب دفع الحجز (`order_payment`)،
  /// فلا يمكن تمييزه إلا من بداية نص الملاحظة
  bool get isPackagePurchase =>
      reason == WalletTransactionReasons.orderPayment &&
      (note?.trimLeft().startsWith('Package purchase') ?? false);

  /// عنوان الحركة بالعربية.
  /// لكل الأسباب فرع افتراضي حتى لا يكسر أي سبب جديد الواجهة.
  String get title {
    switch (reason) {
      case WalletTransactionReasons.orderPayment:
        return isPackagePurchase ? 'شراء باقة' : 'دفع حجز';
      case WalletTransactionReasons.refund:
        return 'استرجاع مبلغ';
      case WalletTransactionReasons.adjustment:
        return isCredit ? 'إضافة رصيد من الدعم' : 'خصم من الدعم';
      case WalletTransactionReasons.topup:
        return 'شحن رصيد';
      default:
        return isCredit ? 'إيداع في المحفظة' : 'خصم من المحفظة';
    }
  }
}
