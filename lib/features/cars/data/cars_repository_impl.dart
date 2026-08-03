import 'package:dartz/dartz.dart';
import 'package:car_care_plus/features/cars/data/car_model.dart';
import 'package:car_care_plus/features/cars/data/cars_remote_data_source.dart';
import 'package:car_care_plus/features/cars/domain/repositories/cars_repository.dart';

class CarsRepositoryImpl implements CarsRepository {
  final CarsRemoteDataSource remoteDataSource;

  CarsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Car>>> getMyCars() async {
    try {
      final cars = await remoteDataSource.getMyCars();
      return Right(cars);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<Either<String, Car>> getCarDetails(int id) async {
    try {
      final car = await remoteDataSource.getCarDetails(id);
      return Right(car);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<Either<String, Unit>> deleteCar(int id) async {
    try {
      await remoteDataSource.deleteCar(id);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
