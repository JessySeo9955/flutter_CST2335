import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'boat_dao.dart';
import 'boat_model.dart';

part 'boat_database.g.dart';

// Floor database configuration for boat storage
@Database(version: 1, entities: [Boat])
abstract class BoatDatabase extends FloorDatabase {
  // Getter for boat data access object
  BoatDao get boatDao;
}

