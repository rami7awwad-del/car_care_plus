import 'package:car_care_plus/features/orders/data/booking_model.dart';

/// ردّ `GET /api/bookings/{id}/rebook`.
///
/// `formDefaults` يُحفظ كخريطة خام لأنه مُشكَّل تماماً مثل جسم طلب التسعيرة،
/// فنعيد إرساله كما هو بعد تعديل ما يختاره المستخدم فقط. هذا يضمن تمرير كل
/// الحقول التي لا نعرضها في الواجهة (المواد، الخدمات الفرعية، تفاصيل السحب
/// والصيانة والمساعدة على الطريق) دون فقدانها.
class RebookPrefillModel {
  final BookingModel? originalBooking;
  final Map<String, dynamic> formDefaults;

  const RebookPrefillModel({
    required this.originalBooking,
    required this.formDefaults,
  });

  factory RebookPrefillModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] as Map : const {};

    final rawBooking = data['booking'];
    final rawDefaults = data['form_defaults'];

    return RebookPrefillModel(
      originalBooking: rawBooking is Map
          ? BookingModel.fromJson(Map<String, dynamic>.from(rawBooking))
          : null,
      formDefaults: rawDefaults is Map
          ? Map<String, dynamic>.from(rawDefaults)
          : <String, dynamic>{},
    );
  }

  // ==================== قراءة الحقول التي تعرضها الواجهة ====================

  /// `true` = حجز فوري، `false` = حجز مجدول
  bool get isImmediate => formDefaults['booking_type'] == true;

  bool get isVip => formDefaults['is_vip'] == true;

  String get paymentMethod =>
      (formDefaults['payment_method'] as String?)?.trim().isNotEmpty == true
      ? formDefaults['payment_method'] as String
      : 'cash';

  String get notes => formDefaults['notes']?.toString() ?? '';

  int? get userPackageId => formDefaults['user_package_id'] as int?;

  int get carCount {
    final ids = formDefaults['car_ids'];
    return ids is List ? ids.length : 1;
  }

  /// المفاتيح الشرطية تظهر فقط إذا كان الحجز الأصلي من نوعها،
  /// لذلك نفحص وجود المفتاح لا قيمته
  bool get isMaintenance => formDefaults.containsKey('workshop_id');
  bool get isTowing => formDefaults.containsKey('destination_lat');
  bool get isRoadAssistance => formDefaults.containsKey('problem_type_id');

  /// جسم طلب التسعيرة: نبدأ من الحقول الأصلية ثم نطبّق تعديلات المستخدم.
  ///
  /// - `service_id` محذوف: نقطة النهاية لا تقبله (تتجاهله وتستخدم خدمة الطلب الأصلي).
  /// - `scheduled_at` يُرسل فقط للحجز المجدول، وإرساله مع الحجز الفوري يعطي 422.
  Map<String, dynamic> buildQuoteBody({
    required bool isImmediate,
    required DateTime? scheduledAt,
    required String paymentMethod,
    required bool isVip,
    required String notes,
    int? userPackageId,
  }) {
    final body = Map<String, dynamic>.from(formDefaults)
      ..remove('service_id')
      ..remove('scheduled_at');

    body['booking_type'] = isImmediate;
    body['is_vip'] = isVip;
    body['payment_method'] = paymentMethod;

    if (notes.trim().isEmpty) {
      body.remove('notes');
    } else {
      body['notes'] = notes.trim();
    }

    if (!isImmediate && scheduledAt != null) {
      body['scheduled_at'] = _formatForApi(scheduledAt);
    }

    // الباقة تُرسل فقط مع طريقة الدفع بالباقة، وباقة الطلب القديم غالباً مستهلكة
    if (paymentMethod == 'package' && userPackageId != null) {
      body['user_package_id'] = userPackageId;
    } else {
      body.remove('user_package_id');
    }

    return body;
  }

  /// `YYYY-MM-DD HH:mm:ss` بالتوقيت المحلي — الصيغة التي يقبلها التحقق في الباك اند
  static String _formatForApi(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)} '
        '${two(date.hour)}:${two(date.minute)}:${two(date.second)}';
  }
}
