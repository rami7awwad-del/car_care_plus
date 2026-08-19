import 'booking_model.dart';

/// قواعد الحجز كما يفرضها الباك اند، محسوبة في العميل حتى تقود الواجهة
/// بدل أن يكتشف المستخدم القاعدة من رسالة خطأ.
class OrderRules {
  const OrderRules._();

  /// نافذة الإلغاء تُغلق قبل 30 دقيقة من الموعد المجدول
  static const Duration cancelWindow = Duration(minutes: 30);

  static const List<String> _cancellableStatuses = ['pending', 'assigned'];

  static String normalizeStatus(String status) => status.trim().toLowerCase();

  static DateTime? scheduledAt(BookingModel order) {
    final raw = order.scheduledAt;
    if (raw == null || raw.isEmpty) return null;
    // تواريخ OrderResource بصيغة ISO-8601 مع الإزاحة، قابلة للتحليل مباشرة
    return DateTime.tryParse(raw)?.toLocal();
  }

  /// آخر لحظة يمكن فيها للزبون الإلغاء
  static DateTime? cancelDeadline(BookingModel order) {
    final date = scheduledAt(order);
    return date?.subtract(cancelWindow);
  }

  /// الزبون يلغي فقط عندما تكون الحالة pending أو assigned
  /// ويتبقّى أكثر من 30 دقيقة على الموعد
  static bool canCancel(BookingModel order) {
    if (!_cancellableStatuses.contains(normalizeStatus(order.status))) {
      return false;
    }
    final deadline = cancelDeadline(order);
    if (deadline == null) return true; // بلا موعد مجدول = بلا قيد زمني
    return DateTime.now().isBefore(deadline);
  }

  /// سبب تعذّر الإلغاء، لعرضه بدل الزر المعطّل
  static String? cancelBlockedReason(BookingModel order) {
    final status = normalizeStatus(order.status);
    if (status == 'cancelled') return 'تم إلغاء هذا الحجز مسبقاً';
    if (status == 'completed') return 'لا يمكن إلغاء حجز مكتمل';
    if (status == 'in_progress') return 'العمل جارٍ على الحجز، تواصل مع الدعم للإلغاء';

    final deadline = cancelDeadline(order);
    if (deadline != null && !DateTime.now().isBefore(deadline)) {
      return 'انتهت مهلة الإلغاء (تُغلق قبل 30 دقيقة من الموعد)';
    }
    return null;
  }

  /// الباك اند لا يقيّد إعادة الحجز بأي حالة، لكن إعادة حجز طلب جارٍ
  /// تجربة مربكة، لذلك نعرض الزر للطلبات المنتهية فقط
  static bool canRebook(BookingModel order) {
    final status = normalizeStatus(order.status);
    return status == 'completed' || status == 'cancelled';
  }

  static String statusLabel(String status) {
    switch (normalizeStatus(status)) {
      case 'pending':
        return 'قيد الانتظار';
      case 'assigned':
        return 'تم تعيين فني';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  /// وقت مختصر بصيغة `YYYY/MM/DD - HH:mm`
  static String formatDateTime(DateTime? date) {
    if (date == null) return 'غير محدد';
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year}/${two(date.month)}/${two(date.day)} - '
        '${two(date.hour)}:${two(date.minute)}';
  }

  static String formatTime(DateTime? date) {
    if (date == null) return '';
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.hour)}:${two(date.minute)}';
  }
}
