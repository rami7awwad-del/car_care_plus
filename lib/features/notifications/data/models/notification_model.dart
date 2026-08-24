/// نوع الإشعار كما يرسله الباك اند: info | warning | success | error
enum NotificationType { info, warning, success, error }

/// أنواع المراجع المعروفة حالياً — القائمة مفتوحة، أي قيمة جديدة تُعامل كـ null
class NotificationReferenceTypes {
  static const String order = 'order';
  static const String payment = 'payment';
  static const String wallet = 'wallet';
  static const String points = 'points';
  static const String rating = 'rating';
  static const String inventory = 'inventory';
  static const String purchaseRequest = 'purchase_request';
  static const String sparePartRequest = 'spare_part_request';
}

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final NotificationType type;
  final String? referenceType;
  final int? referenceId;
  final bool isRead;
  final DateTime? readAt;
  final List<String> sentVia;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.referenceType,
    this.referenceId,
    required this.isRead,
    this.readAt,
    this.sentVia = const [],
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _asInt(json['id']) ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      type: _parseType(json['type']),
      referenceType: json['reference_type']?.toString(),
      referenceId: _asInt(json['reference_id']),
      isRead: json['is_read'] == true || json['is_read'] == 1,
      readAt: parseServerDate(json['read_at']),
      sentVia: json['sent_via'] is List
          ? (json['sent_via'] as List).map((e) => e.toString()).toList()
          : const [],
      createdAt: parseServerDate(json['created_at']),
    );
  }

  NotificationModel copyWith({bool? isRead, DateTime? readAt}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      referenceType: referenceType,
      referenceId: referenceId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      sentVia: sentVia,
      createdAt: createdAt,
    );
  }

  /// هل يمكن الانتقال لشاشة مرتبطة بهذا الإشعار؟
  bool get hasReference => referenceType != null && referenceId != null;

  static NotificationType _parseType(dynamic value) {
    switch (value?.toString()) {
      case 'success':
        return NotificationType.success;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      default:
        // أي نوع جديد أو غير معروف يُعرض كـ info بدل أن يكسر الواجهة
        return NotificationType.info;
    }
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// الباك اند يرسل صيغتين مختلفتين للتواريخ:
  /// - `read_at` بصيغة ISO-8601 مع Z  → "2026-08-17T12:00:00.000000Z"
  /// - `created_at` نص خام من قاعدة البيانات → "2026-08-17 09:12:33" (UTC بدون منطقة زمنية)
  /// لذلك نضيف Z يدوياً عند غيابها وإلا اعتبرها Dart توقيتاً محلياً وظهرت الأوقات خاطئة.
  static DateTime? parseServerDate(dynamic value) {
    if (value == null) return null;
    var raw = value.toString().trim();
    if (raw.isEmpty) return null;

    raw = raw.replaceFirst(' ', 'T');
    final hasTimeZone =
        raw.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(raw);
    if (!hasTimeZone) raw = '${raw}Z';

    return DateTime.tryParse(raw)?.toLocal();
  }
}

/// بيانات الترقيم — تصل في مفتاح `pagination` بجانب `data` وليس داخله
class NotificationsPagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  const NotificationsPagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory NotificationsPagination.fromJson(Map<String, dynamic> json) {
    return NotificationsPagination(
      currentPage: NotificationModel._asInt(json['current_page']) ?? 1,
      perPage: NotificationModel._asInt(json['per_page']) ?? 20,
      total: NotificationModel._asInt(json['total']) ?? 0,
      lastPage: NotificationModel._asInt(json['last_page']) ?? 1,
    );
  }

  bool get hasNextPage => currentPage < lastPage;
}

/// نتيجة صفحة واحدة من قائمة الإشعارات
class NotificationsPage {
  final List<NotificationModel> items;
  final NotificationsPagination pagination;

  const NotificationsPage({required this.items, required this.pagination});
}
