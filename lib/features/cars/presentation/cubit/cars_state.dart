import 'package:car_care_plus/features/cars/data/car_model.dart';

abstract class CarsState {}

class CarsInitial extends CarsState {}

class CarsLoading extends CarsState {}

class CarsLoaded extends CarsState {
  final List<Car> cars;
  CarsLoaded(this.cars);
}

class CarsError extends CarsState {
  final String message;
  CarsError(this.message);
}
