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
  final int? orderId;
  final OrderModel? order;

  PaymentItemModel({
    required this.id,
    required this.paymentNumber,
    required this.type,
    required this.method,
    required this.status,
    required this.amount,
    required this.pointsUsed,
    this.orderId,
    this.order,
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
      orderId: json['order_id'],
      order: json['order'] != null ? OrderModel.fromJson(json['order']) : null,
    );
  }
}

class OrderModel {
  final int id;
  final String status;
  final String? scheduledAt;
  final String? createdAt;
  final String totalPrice;

  OrderModel({
    required this.id,
    required this.status,
    this.scheduledAt,
    this.createdAt,
    required this.totalPrice,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      scheduledAt: json['scheduled_at'],
      createdAt: json['created_at'],
      totalPrice: json['total_price']?.toString() ?? '0.00',
    );
  }
}