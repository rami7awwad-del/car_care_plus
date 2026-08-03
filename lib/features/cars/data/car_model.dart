enum FuelType { petrol, diesel, electric, hybrid }

extension FuelTypeX on FuelType {
  String get apiValue => name;

  String get labelAr {
    switch (this) {
      case FuelType.petrol:
        return 'بنزين';
      case FuelType.diesel:
        return 'ديزل';
      case FuelType.electric:
        return 'كهرباء';
      case FuelType.hybrid:
        return 'هجين';
    }
  }
}

FuelType? _fuelFromString(dynamic value) {
  if (value == null) return null;
  for (final type in FuelType.values) {
    if (type.name == value) return type;
  }
  return null;
}

class CarType {
  final int id;
  final String? name;
  final String? nameAr;

  CarType({required this.id, this.name, this.nameAr});

  factory CarType.fromJson(Map<String, dynamic> json) => CarType(
        id: json['id'] ?? 0,
        name: json['name'],
        nameAr: json['name_ar'],
      );
}

class Branch {
  final int id;
  final String? name;
  final String? nameAr;
  final String? city;

  Branch({required this.id, this.name, this.nameAr, this.city});

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json['id'] ?? 0,
        name: json['name'],
        nameAr: json['name_ar'],
        city: json['city'],
      );
}

class Car {
  final int id;
  final int? userId;
  final int? brandId;
  final int? carTypeId;
  final int? branchId;
  final String? plateNumber;
  final String? model;
  final int? year;
  final String? color;
  final FuelType? fuelType;
  final int? cylinders;
  final int? mileage;
  final String? imageUrl;
  final bool isActive;
  final CarType? carType; // قد يكون null (لا يُحمّل دائماً)
  final Branch? branch; // قد يكون null

  Car({
    required this.id,
    this.userId,
    this.brandId,
    this.carTypeId,
    this.branchId,
    this.plateNumber,
    this.model,
    this.year,
    this.color,
    this.fuelType,
    this.cylinders,
    this.mileage,
    this.imageUrl,
    this.isActive = true,
    this.carType,
    this.branch,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json['id'] ?? 0,
        userId: json['user_id'],
        brandId: json['brand_id'],
        carTypeId: json['car_type_id'],
        branchId: json['branch_id'],
        plateNumber: json['plate_number'],
        model: json['model'],
        year: json['year'],
        color: json['color'],
        fuelType: _fuelFromString(json['fuel_type']),
        cylinders: json['cylinders'],
        mileage: json['mileage'],
        imageUrl: json['image_url'],
        isActive: json['is_active'] == true,
        carType: json['car_type'] is Map
            ? CarType.fromJson(json['car_type'])
            : null,
        branch: json['branch'] is Map ? Branch.fromJson(json['branch']) : null,
      );
}
