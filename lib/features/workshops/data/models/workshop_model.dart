double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

class WorkshopModel {
  final int id;
  final String name;
  final String nameAr;
  final String? address;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String status;
  final double? ratingAvg;
  final double? distanceKm;

  WorkshopModel({
    required this.id,
    required this.name,
    required this.nameAr,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    required this.status,
    this.ratingAvg,
    this.distanceKm,
  });

  String get displayName => nameAr.isNotEmpty ? nameAr : name;

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    return WorkshopModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      address: json['address'] as String?,
      city: json['city'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      status: json['status'] as String? ?? '',
      ratingAvg: _toDouble(json['rating_avg']),
      distanceKm: _toDouble(json['distance_km']),
    );
  }
}
