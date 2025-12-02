import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'boat_dao.dart';
import 'boat_model.dart';

part 'boat_database.g.dart';

/// This is the boat database where we store all boats
@Database(version: 1, entities: [Boat])
abstract class BoatDatabase extends FloorDatabase {
  /// This gives us access to boat operations
  BoatDao get boatDao;
}

