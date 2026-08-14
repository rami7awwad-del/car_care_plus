class BookingConfirmResponseModel {
  final int status;
  final String message;
  final int statusCode;
  final List<ConfirmedBookingData>? data;

  BookingConfirmResponseModel({
    required this.status,
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory BookingConfirmResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingConfirmResponseModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => ConfirmedBookingData.fromJson(e))
              .toList()
          : null,
    );
  }
}

class ConfirmedBookingData {
  final int id;
  final int customerId;
  final int carId;
  final int serviceId;
  final String status;
  final String? scheduledAt;
  final String totalPrice;
  final String? notes;

  ConfirmedBookingData({
    required this.id,
    required this.customerId,
    required this.carId,
    required this.serviceId,
    required this.status,
    this.scheduledAt,
    required this.totalPrice,
    this.notes,
  });

  factory ConfirmedBookingData.fromJson(Map<String, dynamic> json) {
    return ConfirmedBookingData(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      carId: json['car_id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      status: json['status'] ?? '',
      scheduledAt: json['scheduled_at'],
      totalPrice: json['total_price']?.toString() ?? '0.00',
      notes: json['notes'],
    );
  }
}