class PaymentResponseModel {
  final int status;
  final List<PaymentItemModel> data;

  PaymentResponseModel({
    required this.status,
    required this.data,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      status: json['status'] ?? 0,
      data: json['data'] != null
          ? List<PaymentItemModel>.from(
              json['data'].map((x) => PaymentItemModel.fromJson(x)))
          : [],
    );
  }
}

class SinglePaymentResponseModel {
  final int status;
  final PaymentItemModel data;
  final String message;

  SinglePaymentResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory SinglePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return SinglePaymentResponseModel(
      status: json['status'] ?? 0,
      data: PaymentItemModel.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class PaymentItemModel {
  final int id;
  final String paymentNumber;
  final String type;
  final String method;
  final String status;
  final String amount;
  final int pointsUsed;
  final String? createdAt; // 👈 تم إضافة حقل التاريخ

  PaymentItemModel({
    required this.id,
    required this.paymentNumber,
    required this.type,
    required this.method,
    required this.status,
    required this.amount,
    required this.pointsUsed,
    this.createdAt,
  });

  factory PaymentItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentItemModel(
      id: json['id'] ?? 0,
      paymentNumber: json['payment_number'] ?? '',
      type: json['type'] ?? '',
      method: json['method'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount']?.toString() ?? '0.00',
      pointsUsed: json['points_used'] ?? 0,
      createdAt: json['created_at'] ?? json['date'], // 👈 جلب التاريخ
    );
  }
}