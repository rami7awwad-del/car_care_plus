import 'package:flutter/material.dart';

import 'package:car_care_plus/app/app_language.dart';
import 'package:car_care_plus/core/constants/app_colors.dart';

/// فئات خدمة المساعدة على الطريق (PRD - Module 2, الخطوة 1).
enum ServiceCategory { general, mechanical, electrical, fuel, tires, towing }

extension ServiceCategoryX on ServiceCategory {
  String get label {
    switch (this) {
      case ServiceCategory.general:
        return AppStrings.catGeneral;
      case ServiceCategory.mechanical:
        return AppStrings.catMechanical;
      case ServiceCategory.electrical:
        return AppStrings.catElectrical;
      case ServiceCategory.fuel:
        return AppStrings.catFuel;
      case ServiceCategory.tires:
        return AppStrings.catTires;
      case ServiceCategory.towing:
        return AppStrings.catTowing;
    }
  }

  IconData get icon {
    switch (this) {
      case ServiceCategory.general:
        return Icons.search_rounded;
      case ServiceCategory.mechanical:
        return Icons.build_rounded;
      case ServiceCategory.electrical:
        return Icons.electric_bolt_rounded;
      case ServiceCategory.fuel:
        return Icons.local_gas_station_rounded;
      case ServiceCategory.tires:
        return Icons.tire_repair_rounded;
      case ServiceCategory.towing:
        return Icons.local_shipping_rounded;
    }
  }

  /// السعر الأساسي التقديري (ر.س) — قيم mock للعرض في المرحلة 1.
  double get basePrice {
    switch (this) {
      case ServiceCategory.general:
        return 80;
      case ServiceCategory.mechanical:
        return 150;
      case ServiceCategory.electrical:
        return 120;
      case ServiceCategory.fuel:
        return 90;
      case ServiceCategory.tires:
        return 100;
      case ServiceCategory.towing:
        return 200;
    }
  }
}

/// درجة الخطورة (بسيطة / متوسطة / طارئة).
enum Severity { simple, medium, urgent }

extension SeverityX on Severity {
  String get label {
    switch (this) {
      case Severity.simple:
        return AppStrings.sevSimple;
      case Severity.medium:
        return AppStrings.sevMedium;
      case Severity.urgent:
        return AppStrings.sevUrgent;
    }
  }

  Color get color {
    switch (this) {
      case Severity.simple:
        return const Color(0xFF22C55E);
      case Severity.medium:
        return AppColors.secondary;
      case Severity.urgent:
        return AppColors.error;
    }
  }

  /// معامل السعر حسب الأولوية.
  double get multiplier {
    switch (this) {
      case Severity.simple:
        return 1.0;
      case Severity.medium:
        return 1.3;
      case Severity.urgent:
        return 1.6;
    }
  }
}

/// نوع السيارة (صغيرة / SUV / شاحنة).
enum CarType { small, suv, truck }

extension CarTypeX on CarType {
  String get label {
    switch (this) {
      case CarType.small:
        return AppStrings.carSmall;
      case CarType.suv:
        return AppStrings.carSuv;
      case CarType.truck:
        return AppStrings.carTruck;
    }
  }

  IconData get icon {
    switch (this) {
      case CarType.small:
        return Icons.directions_car_rounded;
      case CarType.suv:
        return Icons.airport_shuttle_rounded;
      case CarType.truck:
        return Icons.local_shipping_rounded;
    }
  }

  /// رسوم إضافية حسب حجم السيارة (ر.س).
  double get extraFee {
    switch (this) {
      case CarType.small:
        return 0;
      case CarType.suv:
        return 30;
      case CarType.truck:
        return 60;
    }
  }
}

/// حالات تتبع الطلب — مجموعة فرعية من حالات الطلب في State Chart.
enum TrackingStatus { searching, assigned, enRoute, arrived, inProgress, completed }

extension TrackingStatusX on TrackingStatus {
  String get label {
    switch (this) {
      case TrackingStatus.searching:
        return AppStrings.statusSearching;
      case TrackingStatus.assigned:
        return AppStrings.statusAssigned;
      case TrackingStatus.enRoute:
        return AppStrings.statusEnRoute;
      case TrackingStatus.arrived:
        return AppStrings.statusArrived;
      case TrackingStatus.inProgress:
        return AppStrings.statusInProgress;
      case TrackingStatus.completed:
        return AppStrings.statusCompleted;
    }
  }

  int get index => TrackingStatus.values.indexOf(this);
}

/// بيانات الفني (mock).
class RoadsideEmployee {
  final String name;
  final double rating;
  final String vehicle;
  final String plate;
  final int etaMinutes;

  const RoadsideEmployee({
    required this.name,
    required this.rating,
    required this.vehicle,
    required this.plate,
    required this.etaMinutes,
  });
}
