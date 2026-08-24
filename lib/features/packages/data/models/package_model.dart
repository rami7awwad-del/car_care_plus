class PackageModel {
  final int id;
  final String name;
  final String? description;
  final String type;
  final bool isCompanyPackage;
  final String price;
  final String? discountPct;
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
    this.discountPct,
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
      price: json['price']?.toString() ?? '0',
      discountPct: json['discount_pct']?.toString(),
      servicesCount: json['services_count'] ?? 0,
      validDays: json['valid_days'] ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'is_company_package': isCompanyPackage,
      'price': price,
      'discount_pct': discountPct,
      'services_count': servicesCount,
      'valid_days': validDays,
      'is_active': isActive,
    };
  }
}