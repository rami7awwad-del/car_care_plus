import 'package:dio/dio.dart';

class BookingQuoteRequestBody {
  final List<int> carIds;
  final int serviceId;
  final bool bookingType;
  final String paymentMethod;
  final String? scheduledAt;
  final double locationLat;
  final double locationLng;
  final int isVip;
  final List<int>? subServiceIds;
  final List<Map<String, dynamic>>? materials;
  final String? notes;
  final int? branchId; // 👈 التعديل: تغيير المسمى ليطابق API (branch_id)
  final int? userPackageId; // 👈 إضافة حقل الباقة اختياريًا
  final String? locationAddress;

  BookingQuoteRequestBody({
    required this.carIds,
    required this.serviceId,
    required this.bookingType,
    required this.paymentMethod,
    this.scheduledAt,
    required this.locationLat,
    required this.locationLng,
    required this.isVip,
    this.subServiceIds,
    this.materials,
    this.notes,
    this.branchId,
    this.userPackageId,
    this.locationAddress,
  });

  FormData toFormData() {
    final Map<String, dynamic> map = {};

    // 1. إضافة السيارات car_ids[0]...
    for (int i = 0; i < carIds.length; i++) {
      map['car_ids[$i]'] = carIds[i];
    }

    // 2. الحقول الأساسية
    map['service_id'] = serviceId;

    // API contract: scheduled booking = 0, immediate booking = 1.
    // The local bool is kept as isScheduled, so we map it here.
    map['booking_type'] = bookingType ? '0' : '1';
    map['payment_method'] = paymentMethod;
    map['location_lat'] = locationLat;
    map['location_lng'] = locationLng;
    map['is_vip'] = isVip;

    // Include scheduled_at only for scheduled bookings.
    if (bookingType && scheduledAt != null && scheduledAt!.isNotEmpty) {
      map['scheduled_at'] = scheduledAt;
    }

    if (branchId != null) {
      map['branch_id'] = branchId; // 👈 تم تعديل الاسم من workshop_id إلى branch_id
    }

    if (userPackageId != null) {
      map['user_package_id'] = userPackageId;
    }

    if (locationAddress != null && locationAddress!.isNotEmpty) {
      map['location_address'] = locationAddress;
    }

    if (notes != null && notes!.isNotEmpty) {
      map['notes'] = notes;
    }

    // 4. الخدمات الفرعية
    if (subServiceIds != null) {
      for (int i = 0; i < subServiceIds!.length; i++) {
        map['sub_service_ids[$i]'] = subServiceIds![i];
      }
    }

    // 5. المواد
    if (materials != null) {
      for (int i = 0; i < materials!.length; i++) {
        final material = materials![i];
        material.forEach((key, value) {
          map['materials[$i][$key]'] = value;
        });
      }
    }

    return FormData.fromMap(map);
  }
}