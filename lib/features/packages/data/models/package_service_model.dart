class PackageServiceModel {
  final int id;
  final int packageId;
  final PackageModel package;
  final int serviceId;
  final ServiceModel service;
  final int allowedCount;

  PackageServiceModel({
    required this.id,
    required this.packageId,
    required this.package,
    required this.serviceId,
    required this.service,
    required this.allowedCount,
  });

  factory PackageServiceModel.fromJson(Map<String, dynamic> json) {
    return PackageServiceModel(
      id: json['id'],
      packageId: json['package_id'],
      package: PackageModel.fromJson(json['package']),
      serviceId: json['service_id'],
      service: ServiceModel.fromJson(json['service']),
      allowedCount: json['allowed_count'] ?? 0,
    );
  }
}

class PackageModel {
  final int id;
  final String name;
  final String? description;
  final String type;
  final bool isCompanyPackage;
  final String price;
  final String discountPct;
  final int servicesCount;
  final int validDays;
  final bool isActive;

  PackageModel({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.isCompanyPackage,
    required this.price,
    required this.discountPct,
    required this.servicesCount,
    required this.validDays,
    required this.isActive,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      type: json['type'] ?? '',
      isCompanyPackage: json['is_company_package'] ?? false,
      price: json['price']?.toString() ?? '0.00',
      discountPct: json['discount_pct']?.toString() ?? '0.00',
      servicesCount: json['services_count'] ?? 0,
      validDays: json['valid_days'] ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }
}

class ServiceModel {
  final int id;
  final int categoryId;
  final String name;
  final String nameAr;
  final String? description;
  final String basePrice;
  final bool isVipAvailable;
  final String vipExtraPrice;
  final int durationMinutes;

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.nameAr,
    this.description,
    required this.basePrice,
    required this.isVipAvailable,
    required this.vipExtraPrice,
    required this.durationMinutes,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      description: json['description'],
      basePrice: json['base_price']?.toString() ?? '0.00',
      isVipAvailable: json['is_vip_available'] ?? false,
      vipExtraPrice: json['vip_extra_price']?.toString() ?? '0.00',
      durationMinutes: json['duration_minutes'] ?? 0,
    );
  }
}