import 'package:floor/floor.dart';
import 'boat_model.dart';

/// This helps us talk to the database for boats
@dao
abstract class BoatDao {
  /// This deletes a boat from the database
  @delete
  Future<int> deleteBoat(Boat boat);

  /// This updates a boat that already exists
  @update
  Future<int> updateBoat(Boat boat);

  /// This adds a new boat to the database
  @insert
  Future<int> insertBoat(Boat boat);

  // Query operation - retrieves all boats
  @Query('Select * From Boat')
  Future<List<Boat>> getAllBoats();
}

