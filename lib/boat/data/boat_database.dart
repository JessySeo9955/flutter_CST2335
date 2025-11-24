import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'boat_dao.dart';
import 'boat_model.dart';

part 'boat_database.g.dart';

/// Main Floor database class for managing the Boat entity and
/// providing access to the associated DAO.
@Database(version: 1, entities: [Boat])
abstract class BoatDatabase extends FloorDatabase {

  /// Provides the DAO used to perform CRUD operations on `Boat` records.
  BoatDao get boatDao;
}

