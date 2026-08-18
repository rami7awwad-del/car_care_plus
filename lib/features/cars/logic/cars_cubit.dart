import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/car_model.dart';
import '../data/repos/cars_repo.dart';
import 'cars_state.dart';

class CarsCubit extends Cubit<CarsState> {
  final CarsRepo _carsRepo;

  CarsCubit(this._carsRepo) : super(CarsInitialState());

  List<CarModel> cars = [];
  CarModel? selectedCar;

  /// جلب قائمة جميع سيارات المستخدم
  Future<void> getUserCars() async {
    _safeEmit(CarsLoadingState());
    try {
      cars = await _carsRepo.getUserCars();
      _safeEmit(CarsSuccessState(cars));
    } catch (error) {
      _safeEmit(CarsErrorState(error.toString()));
    }
  }

  /// جلب تفاصيل سيارة محددة
  Future<void> getCarDetails(int carId) async {
    _safeEmit(CarDetailsLoadingState());
    try {
      selectedCar = await _carsRepo.getCarDetails(carId);
      _safeEmit(CarDetailsSuccessState(selectedCar!));
    } catch (error) {
      _safeEmit(CarsErrorState(error.toString()));
    }
  }

  /// إضافة سيارة جديدة
 Future<void> addCar({
  required Map<String, dynamic> carData,
  String? imagePath,
}) async {
  _safeEmit(AddCarLoadingState());
  try {
    final newCar = await _carsRepo.addCar(
      carData: carData,
      imageFile: imagePath != null ? File(imagePath) : null,
    );
    
    // إعادة جلب السيارات الحديثة فوراً لتحديث القائمة بنفس كائنات البيانات القادمة من الباك إند
    await getUserCars();
    
    _safeEmit(AddCarSuccessState(newCar));
  } catch (error) {
    
    _safeEmit(CarsErrorState(error.toString()));
  }
}

  /// تعديل بيانات سيارة
 Future<void> updateCar({
  required int carId,
  required Map<String, dynamic> carData,
  File? imageFile,
}) async {
  _safeEmit(UpdateCarLoadingState());
  try {
    // 1. استقبال كائن السيارة المحدث القادم من السيرفر
    final updatedCar = await _carsRepo.updateCar(
      carId: carId,
      carData: carData,
      imageFile: imageFile,
    );

    // 2. البحث عن مكان السيارة في القائمة
    final index = cars.indexWhere((c) => c.id == carId);
    if (index != -1) {
      // 3. تحديث الكائن داخل القائمة
      cars[index] = updatedCar;
    }
    
    selectedCar = updatedCar;

    // 4. إرسال حالة النجاح لزر الحفظ وإغلاق الشاشة
    _safeEmit(UpdateCarSuccessState(updatedCar));

    // 5. إرسال قائمة السيارات المحدثة مع مصفوفة جديدة لضمان اعادة بناء الواجهة (Rebuild)
    _safeEmit(CarsSuccessState(List.from(cars)));
      getUserCars();
  } catch (error) {
    _safeEmit(CarsErrorState(error.toString()));
  }
}
  /// حذف سيارة
  Future<void> deleteCar(int carId) async {
    _safeEmit(DeleteCarLoadingState());
    try {
      await _carsRepo.deleteCar(carId);
      cars.removeWhere((c) => c.id == carId);
      _safeEmit(DeleteCarSuccessState(carId));
      _safeEmit(CarsSuccessState(cars));
    } catch (error) {
      _safeEmit(CarsErrorState(error.toString()));
    }
  }

List<Map<String, dynamic>> carBrands = [];
List<CarTypeModel> carTypes = [];

/// جلب الماركات والأنواع معاً
Future<void> fetchBrandsAndTypes() async {
  _safeEmit(CarsLoadingState());
  try {
    final results = await Future.wait([
      _carsRepo.getCarBrands(),
      _carsRepo.getCarTypes(),
    ]);
    carBrands = results[0] as List<Map<String, dynamic>>;
    carTypes = results[1] as List<CarTypeModel>;
    _safeEmit(CarsSuccessState(cars));
  } catch (error) {
    _safeEmit(CarsErrorState(error.toString()));
  }
}


  /// يمنع إطلاق حالة بعد إغلاق الـ Cubit.
  /// يحدث ذلك عند مغادرة الشاشة قبل انتهاء طلب الشبكة، لأن CarsCubit يُنشأ
  /// داخل BlocProvider في my_cars_view و service_details_view فيُغلق مع الشاشة.
  void _safeEmit(CarsState state) {
    if (!isClosed) emit(state);
  }
}
