class PointsResponseModel {
  final int? status;
  final PointsData? data;
  final String? message;
  final int? statusCode;

  PointsResponseModel({
    this.status,
    this.data,
    this.message,
    this.statusCode,
  });

  factory PointsResponseModel.fromJson(Map<String, dynamic> json) {
    return PointsResponseModel(
      status: json['status'],
      data: json['data'] != null ? PointsData.fromJson(json['data']) : null,
      message: json['message'],
      statusCode: json['status_code'],
    );
  }
}

class PointsData {
  final int? id;
  final int? customerId;
  final int? balance;

  PointsData({
    this.id,
    this.customerId,

    this.balance,
  });

  factory PointsData.fromJson(Map<String, dynamic> json) {
    return PointsData(
      id: json['id'],
      customerId: json['customer_id'],
      balance: json['balance'],
    );
  }
}