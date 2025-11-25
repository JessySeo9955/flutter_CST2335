import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'car_dao.dart';
import 'car_model.dart';

part 'car_database.g.dart';

/// Floor database configuration for car storage
@Database(
  version: 1,
  entities: [Car],
)
abstract class CarDatabase extends FloorDatabase {
  /// Getter for car data access object
  CarDao get carDao;
}
