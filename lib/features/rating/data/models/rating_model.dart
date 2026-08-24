class RatingModel {
  final int id;
  final int orderId;
  final int? customerId;
  final int? employeeId;
  final int serviceRating;
  final int? employeeRating;
  final int? workshopRating;
  final String? comment;
  final List<String> imageUrls;
  final String? createdAt;

  RatingModel({
    required this.id,
    required this.orderId,
    this.customerId,
    this.employeeId,
    required this.serviceRating,
    this.employeeRating,
    this.workshopRating,
    this.comment,
    this.imageUrls = const [],
    this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as int? ?? 0,
      orderId: json['order_id'] as int? ?? 0,
      customerId: json['customer_id'] as int?,
      employeeId: json['employee_id'] as int?,
      serviceRating: json['service_rating'] as int? ?? 0,
      employeeRating: json['employee_rating'] as int?,
      workshopRating: json['workshop_rating'] as int?,
      comment: json['comment'] as String?,
      imageUrls: (json['image_urls'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      createdAt: json['created_at'] as String?,
    );
  }
}
