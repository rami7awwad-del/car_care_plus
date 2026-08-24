import 'package:dio/dio.dart';

class BookingQuoteRequestBody {
  final List<int> carIds;
  final int serviceId;

  /// true = مجدول (يتطلّب scheduled_at) / false = فوري
  final bool isScheduled;
  final String? scheduledAt;

  final String paymentMethod;
  final bool isVip;
  final List<int>? subServiceIds;
  final List<Map<String, dynamic>>? materials;
  final String? notes;
  final int? userPackageId;

  // الموقع: إمّا GPS (Flow A) أو فرع + عنوان (Flow B) — لا يُرسل الاثنان معاً
  final double? locationLat;
  final double? locationLng;
  final int? branchId;
  final String? locationAddress;

  // حقول حسب نوع الحجز (تُرسَل فقط للنوع المناسب)
  final int? workshopId; // صيانة
  final int? problemTypeId; // طريق
  final String? problemDescription; // طريق
  final String? problemImageUrl; // طريق
  final double? destinationLat; // سحب
  final double? destinationLng; // سحب
  final String? destinationAddress; // سحب

  BookingQuoteRequestBody({
    required this.carIds,
    required this.serviceId,
    required this.isScheduled,
    this.scheduledAt,
    required this.paymentMethod,
    this.isVip = false,
    this.subServiceIds,
    this.materials,
    this.notes,
    this.userPackageId,
    this.locationLat,
    this.locationLng,
    this.branchId,
    this.locationAddress,
    this.workshopId,
    this.problemTypeId,
    this.problemDescription,
    this.problemImageUrl,
    this.destinationLat,
    this.destinationLng,
    this.destinationAddress,
  });

  FormData toFormData() {
    final Map<String, dynamic> map = {};

    // السيارات: car_ids[0]...
    for (int i = 0; i < carIds.length; i++) {
      map['car_ids[$i]'] = carIds[i];
    }

    map['service_id'] = serviceId;

    // booking_type: 1 = فوري / 0 = مجدول (حسب الدليل)
    map['booking_type'] = isScheduled ? 0 : 1;
    map['payment_method'] = paymentMethod;
    map['is_vip'] = isVip ? 1 : 0;

    // scheduled_at يُرسَل فقط للحجز المجدول
    if (isScheduled && scheduledAt != null && scheduledAt!.isNotEmpty) {
      map['scheduled_at'] = scheduledAt;
    }

    if (userPackageId != null) {
      map['user_package_id'] = userPackageId;
    }

    if (notes != null && notes!.isNotEmpty) {
      map['notes'] = notes;
    }

    // الموقع: للفرع أولوية (Flow B)، وإلا GPS (Flow A) — لا يُرسل الاثنان
    if (branchId != null) {
      map['branch_id'] = branchId;
      if (locationAddress != null && locationAddress!.isNotEmpty) {
        map['location_address'] = locationAddress;
      }
    } else if (locationLat != null && locationLng != null) {
      map['location_lat'] = locationLat;
      map['location_lng'] = locationLng;
    }

    // الخدمات الفرعية
    if (subServiceIds != null) {
      for (int i = 0; i < subServiceIds!.length; i++) {
        map['sub_service_ids[$i]'] = subServiceIds![i];
      }
    }

    // المواد: materials[i][key]
    if (materials != null) {
      for (int i = 0; i < materials!.length; i++) {
        materials![i].forEach((key, value) {
          map['materials[$i][$key]'] = value;
        });
      }
    }

    // حقول النوع (طريق)
    if (problemTypeId != null) map['problem_type_id'] = problemTypeId;
    if (problemDescription != null && problemDescription!.isNotEmpty) {
      map['problem_description'] = problemDescription;
    }
    if (problemImageUrl != null && problemImageUrl!.isNotEmpty) {
      map['problem_image_url'] = problemImageUrl;
    }

    // حقول النوع (سحب)
    if (destinationLat != null) map['destination_lat'] = destinationLat;
    if (destinationLng != null) map['destination_lng'] = destinationLng;
    if (destinationAddress != null && destinationAddress!.isNotEmpty) {
      map['destination_address'] = destinationAddress;
    }

    // حقول النوع (صيانة)
    if (workshopId != null) map['workshop_id'] = workshopId;

    return FormData.fromMap(map);
  }
}
