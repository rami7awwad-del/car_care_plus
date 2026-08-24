import '../data/models/material_model.dart';

abstract class MaterialsState {}

/// الحالة الابتدائية
class MaterialsInitialState extends MaterialsState {}

/// حالة تحميل المواد من API
class MaterialsLoadingState extends MaterialsState {}

/// حالة نجاح جلب البيانات وتمرير القائمة
class MaterialsSuccessState extends MaterialsState {
  final List<MaterialModel> materials;

  MaterialsSuccessState(this.materials);
}

/// حالة حدوث خطأ أثناء جلب البيانات
class MaterialsErrorState extends MaterialsState {
  final String message;

  MaterialsErrorState(this.message);
}