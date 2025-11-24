import 'package:floor/floor.dart';

import 'boat_model.dart';

/// Data access object (DAO) for performing CRUD operations on `Boat`
/// entities stored in the local database.
@dao
abstract class BoatDao {

  /// Returns all boats from the database.
  @Query('Select * From Boat')
  Future<List<Boat>> getAllBoats();

  /// Inserts a new `Boat` into the database.
  /// Returns a `Future` containing the ID of the newly inserted row.
  @insert
  Future<int> insertBoat(Boat boat);

  /// Updates a specific `Boat` in the database.
  @update
  Future<int> updateBoat(Boat boat);

  /// Deletes a specific `Boat` from the database.
  @delete
  Future<int> deleteBoat(Boat boat);
}

