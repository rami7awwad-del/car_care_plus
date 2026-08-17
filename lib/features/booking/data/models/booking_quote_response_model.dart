/// يحوّل القيم الرقمية سواء جاءت رقماً أو نصاً (المبالغ decimal تأتي كنصوص)
double? _toDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

double _toDouble(dynamic value) => _toDoubleOrNull(value) ?? 0.0;

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
  final double? cashDueTotal; // المتبقّي نقداً عند استخدام باقة
  final double? distanceKm;
  final int? carCount;
  final String? expiresAt;
  final List<InvoiceItem> invoice;

  // تدفّق اختيار الباقة
  final bool requiresPackageSelection;
  final List<AvailablePackage> availablePackages;

  QuoteData({
    required this.quoteToken,
    required this.totalPrice,
    this.cashDueTotal,
    this.distanceKm,
    this.carCount,
    this.expiresAt,
    this.invoice = const [],
    this.requiresPackageSelection = false,
    this.availablePackages = const [],
  });

  factory QuoteData.fromJson(Map<String, dynamic> json) {
    return QuoteData(
      quoteToken: json['quote_token'] ?? '',
      totalPrice: _toDouble(json['total_price']),
      cashDueTotal: _toDoubleOrNull(json['cash_due_total']),
      distanceKm: _toDoubleOrNull(json['distance_km']),
      carCount: json['car_count'] as int?,
      expiresAt: json['expires_at'],
      invoice: json['invoice'] != null
          ? (json['invoice'] as List)
              .map((e) => InvoiceItem.fromJson(e))
              .toList()
          : const [],
      requiresPackageSelection: json['requires_package_selection'] == true,
      availablePackages: json['available_packages'] != null
          ? (json['available_packages'] as List)
              .map((e) => AvailablePackage.fromJson(e))
              .toList()
          : const [],
    );
  }
}

class InvoiceItem {
  final int? carId;
  final double servicePrice;
  final double subServicePrice;
  final double materialsPrice;
  final double totalPrice;
  final double? packageCoveredAmount;
  final double? cashDueAmount;
  final List<PriceDetailItem> priceItems;

  InvoiceItem({
    this.carId,
    required this.servicePrice,
    required this.subServicePrice,
    required this.materialsPrice,
    required this.totalPrice,
    this.packageCoveredAmount,
    this.cashDueAmount,
    this.priceItems = const [],
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      carId: json['car_id'],
      servicePrice: _toDouble(json['service_price']),
      subServicePrice: _toDouble(json['sub_service_price']),
      materialsPrice: _toDouble(json['materials_price']),
      totalPrice: _toDouble(json['total_price']),
      packageCoveredAmount: _toDoubleOrNull(json['package_covered_amount']),
      cashDueAmount: _toDoubleOrNull(json['cash_due_amount']),
      priceItems: json['price_items'] != null
          ? (json['price_items'] as List)
              .map((e) => PriceDetailItem.fromJson(e))
              .toList()
          : const [],
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
      amount: _toDouble(json['amount']),
    );
  }
}

/// باقة متاحة لهذا الحجز (من ردّ "اختر باقة")
class AvailablePackage {
  final int id;
  final String name;

  AvailablePackage({required this.id, required this.name});

  factory AvailablePackage.fromJson(Map<String, dynamic> json) {
    final details = json['package_details'] ?? json['package'];
    final name = (details is Map ? details['name'] : null) ??
        json['name'] ??
        'باقة';
    return AvailablePackage(
      id: json['id'] as int? ?? 0,
      name: name.toString(),
    );
  }
}
