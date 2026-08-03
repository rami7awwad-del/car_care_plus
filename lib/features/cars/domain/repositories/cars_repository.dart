import 'package:dartz/dartz.dart';
import 'package:car_care_plus/features/cars/data/car_model.dart';

abstract class CarsRepository {
  Future<Either<String, List<Car>>> getMyCars();
  Future<Either<String, Car>> getCarDetails(int id);
  Future<Either<String, Unit>> deleteCar(int id);
}
