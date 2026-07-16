import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/roadside_models.dart';

/// عدد خطوات المعالج (Service → Details → Location → Review).
const int kRoadsideStepCount = 4;

/// المسافة التقديرية (mock) المستخدمة في حساب السعر.
const double _kDistanceFee = 25;

class RoadsideRequestState {
  final int step;
  final ServiceCategory? category;
  final Severity severity;
  final CarType carType;
  final String description;
  final bool hasPhoto;
  final bool locationSet;

  const RoadsideRequestState({
    this.step = 0,
    this.category,
    this.severity = Severity.medium,
    this.carType = CarType.small,
    this.description = '',
    this.hasPhoto = false,
    this.locationSet = false,
  });

  bool get isLastStep => step == kRoadsideStepCount - 1;

  /// السعر التقديري = (أساسي × معامل الخطورة) + رسوم الحجم + رسوم المسافة.
  double get totalPrice {
    if (category == null) return 0;
    return (category!.basePrice * severity.multiplier) + carType.extraFee + _kDistanceFee;
  }

  RoadsideRequestState copyWith({
    int? step,
    ServiceCategory? category,
    Severity? severity,
    CarType? carType,
    String? description,
    bool? hasPhoto,
    bool? locationSet,
  }) {
    return RoadsideRequestState(
      step: step ?? this.step,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      carType: carType ?? this.carType,
      description: description ?? this.description,
      hasPhoto: hasPhoto ?? this.hasPhoto,
      locationSet: locationSet ?? this.locationSet,
    );
  }
}

/// حالة معالج طلب المساعدة على الطريق (Cubit — يتوافق مع اختيار المشروع لـ flutter_bloc).
class RoadsideRequestCubit extends Cubit<RoadsideRequestState> {
  RoadsideRequestCubit() : super(const RoadsideRequestState());

  void selectCategory(ServiceCategory category) => emit(state.copyWith(category: category));
  void setSeverity(Severity severity) => emit(state.copyWith(severity: severity));
  void setCarType(CarType carType) => emit(state.copyWith(carType: carType));
  void setDescription(String value) => emit(state.copyWith(description: value));
  void togglePhoto() => emit(state.copyWith(hasPhoto: !state.hasPhoto));
  void setLocation() => emit(state.copyWith(locationSet: true));

  void nextStep() {
    if (state.step < kRoadsideStepCount - 1) emit(state.copyWith(step: state.step + 1));
  }

  void previousStep() {
    if (state.step > 0) emit(state.copyWith(step: state.step - 1));
  }

  /// هل يمكن الانتقال من الخطوة الحالية؟ (تحقق بسيط لكل خطوة).
  bool canAdvance() {
    switch (state.step) {
      case 0:
        return state.category != null; // يجب اختيار نوع الخدمة
      case 2:
        return state.locationSet; // يجب تحديد الموقع
      default:
        return true;
    }
  }
}
