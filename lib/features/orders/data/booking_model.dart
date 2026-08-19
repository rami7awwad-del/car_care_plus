/// كل تواريخ الحجز بصيغة ISO-8601 مع الإزاحة، قابلة للتحليل مباشرة
DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  final raw = value.toString().trim();
  if (raw.isEmpty) return null;
  return DateTime.tryParse(raw)?.toLocal();
}

class BookingModel {
  final int id;
  final String status;
  final String? scheduledAt;
  final String totalPrice;
  final String? notes;
  final CarModel? car;
  final ServiceModel? service;
  final WorkshopModel? workshop;

  // ==================== تواريخ دورة حياة الحجز ====================
  // كل تاريخ يبقى null حتى تحدث مرحلته

  /// لحظة إنشاء الحجز — لا يوجد لها سطر في سجل الحالات، فتُبنى منها
  /// مرحلة "تم إنشاء الطلب" يدوياً
  final DateTime? createdAt;
  final DateTime? assignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  /// سبب الإلغاء موجود على الطلب نفسه لا في سجل الحالات
  final String? cancelReason;

  final int? employeeId;

  /// اسم الفني المسؤول حالياً — نقرأ الاسم فقط ونتجاهل بريده وهاتفه
  final String? employeeName;

  BookingModel({
    required this.id,
    required this.status,
    this.scheduledAt,
    required this.totalPrice,
    this.notes,
    this.car,
    this.service,
    this.workshop,
    this.createdAt,
    this.assignedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelReason,
    this.employeeId,
    this.employeeName,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      scheduledAt: json['scheduled_at'],
      totalPrice: json['total_price']?.toString() ?? '0.00',
      notes: json['notes'],
      car: json['car'] != null ? CarModel.fromJson(json['car']) : null,
      service: json['service'] != null ? ServiceModel.fromJson(json['service']) : null,
      workshop: json['workshop'] != null ? WorkshopModel.fromJson(json['workshop']) : null,
      createdAt: _parseDate(json['created_at']),
      assignedAt: _parseDate(json['assigned_at']),
      startedAt: _parseDate(json['started_at']),
      completedAt: _parseDate(json['completed_at']),
      cancelledAt: _parseDate(json['cancelled_at']),
      cancelReason: json['cancel_reason']?.toString(),
      employeeId: json['employee_id'] is int ? json['employee_id'] as int : null,
      employeeName: _readEmployeeName(json['employee']),
    );
  }

  static String? _readEmployeeName(dynamic employee) {
    if (employee is! Map) return null;
    final user = employee['user'];
    if (user is! Map) return null;
    final name = user['name']?.toString().trim();
    return (name == null || name.isEmpty) ? null : name;
  }
}

class CarModel {
  final int id;
  final String plateNumber;
  final String model;
  final String year;

  CarModel({
    required this.id,
    required this.plateNumber,
    required this.model,
    required this.year,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? 0,
      plateNumber: json['plate_number'] ?? '',
      model: json['model'] ?? '',
      year: json['year']?.toString() ?? '',
    );
  }
}

class ServiceModel {
  final int id;
  final String name;
  final String nameAr;

  ServiceModel({
    required this.id,
    required this.name,
    required this.nameAr,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
    );
  }
}

class WorkshopModel {
  final int id;
  final String name;
  final String nameAr;

  WorkshopModel({
    required this.id,
    required this.name,
    required this.nameAr,
  });

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    return WorkshopModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
    );
  }
}