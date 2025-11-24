import 'package:floor/floor.dart';
import 'boat_model.dart';

// DAO interface for boat database operations
@dao
abstract class BoatDao {
  // Delete operation - removes boat record
  @delete
  Future<int> deleteBoat(Boat boat);

  // Update operation - modifies existing boat
  @update
  Future<int> updateBoat(Boat boat);

  // Insert operation - adds new boat record
  @insert
  Future<int> insertBoat(Boat boat);

  // Query operation - retrieves all boats
  @Query('Select * From Boat')
  Future<List<Boat>> getAllBoats();
}

