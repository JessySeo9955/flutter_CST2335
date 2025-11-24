import '../data/boat_dao.dart';
import '../data/boat_database.dart';
import '../data/boat_model.dart';
import '../preference/boat_prefs.dart';

/// This service abstracts away the DAO and shared preferences logic,
/// providing a clean API for the UI layer.
class BoatService {

  // 1. Private constructor
  /// Internal private constructor used to implement the singleton pattern.
  BoatService._internal();

  // 2. Single static instance
  /// The single shared instance of [BoatService].
  static final BoatService _instance = BoatService._internal();

  // 3. Public static accessor
  /// Provides global access to the singleton service instance.
  factory BoatService() => _instance;

  /// Data access object used for database operations on `Boat` entities.
  late BoatDao _dao;

  /// Initializes the Floor database and prepares the DAO for use.
  Future<void> init() async {
    final db = await $FloorBoatDatabase
        .databaseBuilder("boat.db")
        .build();

    _dao = db.boatDao;
  }

  /// Validates that all required fields in a `Boat` object are non-empty.
  bool validateFields(Boat boat) {
    return boat.yearBuilt.isNotEmpty &&
        boat.boatLength.isNotEmpty &&
        boat.powerType.isNotEmpty &&
        boat.price.isNotEmpty &&
        boat.address.isNotEmpty;
  }

  /// Saves a new `Boat` to the database and stores the same data in
  /// encrypted shared preferences as the "last used boat".
  Future<void> saveBoat(Boat boat) async {
    await _dao.insertBoat(boat);

    await BoatPrefs.saveLastBoat({
      "yearBuilt": boat.yearBuilt,
      "boatLength": boat.boatLength,
      "powerType": boat.powerType,
      "price": boat.price,
      "address": boat.address,
    });
  }

  /// Updates an existing `Boat` in the database.
  Future<int> updateBoat(Boat boat) async {
    return await _dao.updateBoat(boat);
  }

  /// Deletes a specific `Boat` from the database.
  Future<void> deleteBoat(Boat boat) async {
    await _dao.deleteBoat(boat);
  }

  /// Retrieves all saved boats from the database.
  Future<List<Boat>> getBoats() {
    return _dao.getAllBoats();
  }

  /// Loads the most recently saved boat from encrypted preferences.
  Future<Boat?> loadLastBoat() async {
    Map<String, String>? saved = await BoatPrefs.loadLastBoat();
    if (saved == null) return null;
    return Boat(
      yearBuilt: saved['yearBuilt'] ?? "",
      boatLength: saved['boatLength'] ?? "",
      powerType: saved['powerType'] ?? "",
      price: saved['price'] ?? "",
      address: saved['address'] ?? "",
    );
  }
}

