class BookingQuoteResponseModel {
  final int status;
  final String message;
  final int statusCode;
  final QuoteData? data;

  BookingQuoteResponseModel({
    required this.status,
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory BookingQuoteResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingQuoteResponseModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
      data: json['data'] != null ? QuoteData.fromJson(json['data']) : null,
    );
  }
}

class QuoteData {
  final String quoteToken;
  final double totalPrice;
  final String? expiresAt;
  final List<InvoiceItem>? invoice;

  QuoteData({
    required this.quoteToken,
    required this.totalPrice,
    this.expiresAt,
    this.invoice,
  });

  factory QuoteData.fromJson(Map<String, dynamic> json) {
    return QuoteData(
      quoteToken: json['quote_token'] ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      expiresAt: json['expires_at'],
      invoice: json['invoice'] != null
          ? (json['invoice'] as List)
              .map((e) => InvoiceItem.fromJson(e))
              .toList()
          : null,
    );
  }
}

class InvoiceItem {
  final int? carId;
  final double servicePrice;
  final double subServicePrice;
  final double materialsPrice;
  final double totalPrice;
  final List<PriceDetailItem>? priceItems;

  InvoiceItem({
    this.carId,
    required this.servicePrice,
    required this.subServicePrice,
    required this.materialsPrice,
    required this.totalPrice,
    this.priceItems,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      carId: json['car_id'],
      servicePrice: (json['service_price'] as num?)?.toDouble() ?? 0.0,
      subServicePrice: (json['sub_service_price'] as num?)?.toDouble() ?? 0.0,
      materialsPrice: (json['materials_price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      priceItems: json['price_items'] != null
          ? (json['price_items'] as List)
              .map((e) => PriceDetailItem.fromJson(e))
              .toList()
          : null,
    );
  }
}

class PriceDetailItem {
  final String label;
  final double amount;

  PriceDetailItem({required this.label, required this.amount});

  factory PriceDetailItem.fromJson(Map<String, dynamic> json) {
    return PriceDetailItem(
      label: json['label'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}