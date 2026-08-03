import 'package:dartz/dartz.dart';
import 'package:car_care_plus/features/cars/data/car_model.dart';
import '../repositories/cars_repository.dart';

class GetCarDetailsUseCase {
  final CarsRepository repository;

  GetCarDetailsUseCase(this.repository);

  Future<Either<String, Car>> call(int id) {
    return repository.getCarDetails(id);
  }
}
