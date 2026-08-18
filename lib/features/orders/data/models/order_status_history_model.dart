/// سطر واحد من سجل تغيّر حالة الحجز.
///
/// ملاحظتان من الباك اند:
/// - `note` فارغ دائماً: العمود والمعامل موجودان لكن لا مكان يمرّر قيمة،
///   وسبب الإلغاء يوجد على الطلب نفسه لا هنا.
/// - `employee_id` يكون null عندما يُلغي الزبون أو الإدارة، ويبقى مفتاح
///   `employee` موجوداً لكن فارغاً — لذلك نعتمد على المعرّف لا على وجود الكائن.
class OrderStatusHistoryModel {
  final int id;
  final int orderId;
  final int? employeeId;

  /// اسم الفني فقط — الرد يحوي بريده وهاتفه ولا يجوز عرضهما للزبون
  final String? employeeName;

  final String fromStatus;
  final String toStatus;
  final DateTime? createdAt;

  const OrderStatusHistoryModel({
    required this.id,
    required this.orderId,
    this.employeeId,
    this.employeeName,
    required this.fromStatus,
    required this.toStatus,
    this.createdAt,
  });

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['created_at']?.toString();

    return OrderStatusHistoryModel(
      id: json['id'] is int ? json['id'] as int : 0,
      orderId: json['order_id'] is int ? json['order_id'] as int : 0,
      employeeId: json['employee_id'] is int ? json['employee_id'] as int : null,
      employeeName: _readEmployeeName(json['employee']),
      fromStatus: json['from_status']?.toString() ?? '',
      toStatus: json['to_status']?.toString() ?? '',
      createdAt: rawDate == null ? null : DateTime.tryParse(rawDate)?.toLocal(),
    );
  }

  /// تم التنفيذ بواسطة فني؟ نعتمد على المعرّف لا على وجود كائن الموظف
  bool get isByEmployee => employeeId != null;

  static String? _readEmployeeName(dynamic employee) {
    if (employee is! Map) return null;
    final user = employee['user'];
    if (user is! Map) return null;
    final name = user['name']?.toString().trim();
    return (name == null || name.isEmpty) ? null : name;
  }
}

class OrderStatusHistoryResponseModel {
  final int status;
  final String message;
  final List<OrderStatusHistoryModel> data;

  const OrderStatusHistoryResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderStatusHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];

    return OrderStatusHistoryResponseModel(
      status: json['status'] is int ? json['status'] as int : 0,
      message: json['message']?.toString() ?? '',
      // الاستجابة مجموعة عادية غير مرقّمة، مرتّبة من الأقدم للأحدث
      data: rawList is List
          ? rawList
                .whereType<Map>()
                .map(
                  (e) => OrderStatusHistoryModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
          : const [],
    );
  }
}
