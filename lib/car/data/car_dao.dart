import 'package:floor/floor.dart';
import 'car_model.dart';

/// DAO interface for car database operations
@dao
abstract class CarDao {
  /// Delete operation - removes a car record
  @delete
  Future<int> deleteCar(Car car);

  /// Update operation - modifies an existing car
  @update
  Future<int> updateCar(Car car);

  /// Insert operation - adds a new car record
  @insert
  Future<int> insertCar(Car car);

  /// Query operation - retrieves all cars
  @Query('SELECT * FROM Car')
  Future<List<Car>> getAllCars();
}
