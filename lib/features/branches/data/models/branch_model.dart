import 'dart:math' as math;

/// الإحداثيات تصل كنصوص (decimal بلا cast) وقد تكون null،
/// لذلك نحوّلها مرة واحدة هنا بدل التعامل معها في الواجهة.
double? _toDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

class BranchModel {
  final int id;
  final int adminId;
  final String name;
  final String nameAr;
  final String city;
  final String address;

  /// قد تكون null — الفرع بلا إحداثيات لا يظهر على الخريطة ولا يُختار كأقرب فرع
  final double? latitude;
  final double? longitude;

  final String phone;
  final bool isActive;
  final bool is24h;

  /// حقل JSON حرّ بلا أي تحقق من الشكل في الباك اند — لا يُقرأ بمفتاح ثابت
  final dynamic workingHours;

  const BranchModel({
    required this.id,
    required this.adminId,
    required this.name,
    required this.nameAr,
    required this.city,
    required this.address,
    this.latitude,
    this.longitude,
    required this.phone,
    required this.isActive,
    required this.is24h,
    this.workingHours,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: _toInt(json['id']),
      adminId: _toInt(json['admin_id']),
      name: json['name']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: _toDoubleOrNull(json['latitude']),
      longitude: _toDoubleOrNull(json['longitude']),
      phone: json['phone']?.toString() ?? '',
      // is_active و is_24h مُحوّلان فعلاً إلى boolean في الباك اند
      isActive: json['is_active'] == true || json['is_active'] == 1,
      is24h: json['is_24h'] == true || json['is_24h'] == 1,
      workingHours: json['working_hours'],
    );
    // ملاحظة: نتجاهل `manager` عمداً — يحتوي بريد وهاتف موظف الفرع
    // ولا يجوز عرضه في واجهة الزبون.
  }

  /// الاسم المعروض: الواجهة عربية والـ API يعيد الاسمين دائماً
  /// دون النظر إلى Accept-Language
  String get displayName => nameAr.trim().isNotEmpty ? nameAr : name;

  bool get hasCoordinates => latitude != null && longitude != null;

  /// الفرع صالح للحجز والترتيب حسب المسافة
  bool get isSelectable => isActive && hasCoordinates;

  /// ساعات العمل بشكل دفاعي: الباك اند يستخدم شكلين مختلفين
  /// (`{start,end}` في الـ seeder و`{mon,tue,…}` في الـ factory)
  /// وأي شكل غير معروف يعيد null بدل أن يكسر الواجهة.
  String? get formattedWorkingHours {
    final hours = workingHours;
    if (hours is! Map) return null;

    final start = hours['start'];
    final end = hours['end'];
    if (start is String && end is String) return '$start - $end';

    final days = hours.entries
        .where((entry) => entry.value is String)
        .map((entry) => '${entry.key}: ${entry.value}')
        .toList();
    return days.isEmpty ? null : days.join('  •  ');
  }

  /// المسافة بالكيلومترات بنفس معادلة الباك اند (Haversine بنصف قطر 6371 كم).
  /// للعرض فقط — المسافة المعتمدة تأتي من ردّ التسعيرة.
  double? distanceKmFrom(double? userLat, double? userLng) {
    if (userLat == null || userLng == null || !hasCoordinates) return null;

    const earthRadiusKm = 6371.0;
    double toRadians(double degrees) => degrees * math.pi / 180;

    final dLat = toRadians(latitude! - userLat);
    final dLng = toRadians(longitude! - userLng);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(toRadians(userLat)) *
            math.cos(toRadians(latitude!)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final distance =
        earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return (distance * 100).round() / 100;
  }
}

class BranchesPagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  const BranchesPagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory BranchesPagination.fromJson(Map<String, dynamic> json) {
    return BranchesPagination(
      currentPage: _toInt(json['current_page']),
      perPage: _toInt(json['per_page']),
      total: _toInt(json['total']),
      lastPage: _toInt(json['last_page']),
    );
  }

  bool get hasNextPage => currentPage < lastPage;
}

class BranchesResponseModel {
  final int status;
  final String message;
  final List<BranchModel> data;
  final BranchesPagination? pagination;

  const BranchesResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory BranchesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    // بيانات الترقيم مفتاح مجاور لـ data وليست داخله
    final rawPagination = json['pagination'];

    return BranchesResponseModel(
      status: _toInt(json['status']),
      message: json['message']?.toString() ?? '',
      data: rawList is List
          ? rawList
                .whereType<Map>()
                .map((e) => BranchModel.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : const [],
      pagination: rawPagination is Map
          ? BranchesPagination.fromJson(Map<String, dynamic>.from(rawPagination))
          : null,
    );
  }
}
