class WalletTransactionResponseModel {
  final int status;
  final List<WalletTransactionItemModel> data;

  WalletTransactionResponseModel({
    required this.status,
    required this.data,
  });

  factory WalletTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionResponseModel(
      status: json['status'] ?? 0,
      data: json['data'] != null
          ? List<WalletTransactionItemModel>.from(
              json['data'].map((x) => WalletTransactionItemModel.fromJson(x)))
          : [],
    );
  }
}

class WalletTransactionItemModel {
  final int id;
  final int walletId;
  final String amount;
  final String type; // credit / debit
  final String? description;
  final String? createdAt;

  WalletTransactionItemModel({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    this.description,
    this.createdAt,
  });

  factory WalletTransactionItemModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionItemModel(
      id: json['id'] ?? 0,
      walletId: json['wallet_id'] ?? 0,
      amount: json['amount']?.toString() ?? '0.00',
      type: json['type'] ?? '',
      description: json['description'],
      createdAt: json['created_at'],
    );
  }
}