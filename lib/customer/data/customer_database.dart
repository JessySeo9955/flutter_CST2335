import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'customer_dao.dart';
import 'customer_model.dart';

part 'customer_database.g.dart';

/// Main Floor database class for managing the Customer entity and
/// providing access to the associated DAO.
@Database(version: 1, entities: [Customer])
abstract class CustomerDatabase extends FloorDatabase {

  /// Provides the DAO used to perform CRUD operations on `Customer` records.
  CustomerDao get customerDao;
}