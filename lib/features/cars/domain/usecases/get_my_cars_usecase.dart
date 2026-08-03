import 'package:dartz/dartz.dart';
import 'package:car_care_plus/features/cars/data/car_model.dart';
import '../repositories/cars_repository.dart';

class GetMyCarsUseCase {
  final CarsRepository repository;

  GetMyCarsUseCase(this.repository);

  Future<Either<String, List<Car>>> call() {
    return repository.getMyCars();
  }
}
