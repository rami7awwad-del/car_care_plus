import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care_plus/features/cars/data/car_model.dart';
import 'package:car_care_plus/features/cars/domain/repositories/cars_repository.dart';
import 'package:car_care_plus/features/cars/presentation/cubit/cars_state.dart';

class CarsCubit extends Cubit<CarsState> {
  final CarsRepository carsRepository;
  List<Car> _cars = [];

  CarsCubit({required this.carsRepository}) : super(CarsInitial());

  // جلب سيارات المستخدم الحالي
  Future<void> getMyCars() async {
    emit(CarsLoading());

    final result = await carsRepository.getMyCars();

    result.fold(
      (failureMessage) => emit(CarsError(failureMessage)),
      (cars) {
        _cars = cars;
        emit(CarsLoaded(cars));
      },
    );
  }

  // حذف سيارة؛ يعيد رسالة الخطأ أو null عند النجاح
  Future<String?> deleteCar(int id) async {
    final result = await carsRepository.deleteCar(id);

    return result.fold(
      (failureMessage) => failureMessage,
      (_) {
        _cars = _cars.where((car) => car.id != id).toList();
        emit(CarsLoaded(_cars));
        return null;
      },
    );
  }
}
