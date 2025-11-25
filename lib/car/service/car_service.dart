import '../data/car_database.dart';
import '../data/car_model.dart';

/// Service layer wrapping the CarDao for cleaner access.
///
/// Your UI pages (CarListPage, CarFormPage) will use this instead of
/// calling the DAO directly. This keeps the architecture modular.
class CarService {
  final CarDatabase _database;

  CarService(this._database);

  /// Returns a list of all cars in the database.
  Future<List<Car>> getAllCars() => _database.carDao.getAllCars();

  /// Inserts a new car into the database.
  Future<int> insertCar(Car car) => _database.carDao.insertCar(car);

  /// Updates an existing car.
  Future<int> updateCar(Car car) => _database.carDao.updateCar(car);

  /// Deletes a car.
  Future<int> deleteCar(Car car) => _database.carDao.deleteCar(car);
}
