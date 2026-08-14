class MaterialModel {
  final int id;
  final String name;
  final String nameAr;
  final double price;
  final String? description;

  MaterialModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.price,
    this.description,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      // ⚠️ هنا التعديل: قراءة unit_price بدلاً من price
      price: double.tryParse(json['unit_price']?.toString() ?? json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description'] as String?,
    );
  }
}