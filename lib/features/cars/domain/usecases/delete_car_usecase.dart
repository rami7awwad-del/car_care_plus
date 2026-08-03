import 'package:dartz/dartz.dart';
import '../repositories/cars_repository.dart';

class DeleteCarUseCase {
  final CarsRepository repository;

  DeleteCarUseCase(this.repository);

  Future<Either<String, Unit>> call(int id) {
    return repository.deleteCar(id);
  }
}
