import '../data/boat_dao.dart';
import '../data/boat_database.dart';
import '../data/boat_model.dart';
import '../preference/boat_prefs.dart';

/// This service helps us work with boats
class BoatService {
  /// This creates only one copy of the service for the whole app
  static final BoatService _singleton = BoatService._privateConstructor();
  
  /// This is the private constructor so no one else can create a copy
  BoatService._privateConstructor();
  
  /// This returns the same service every time
  factory BoatService() => _singleton;

  /// This helps us talk to the database
  late BoatDao _boatDao;

  /// This sets up the database when the app starts
  Future<void> init() async {
    final database = await $FloorBoatDatabase.databaseBuilder("boat.db").build();
    _boatDao = database.boatDao;
  }

  /// This gets all boats from the database
  Future<List<Boat>> getBoats() {
    return _boatDao.getAllBoats();
  }

  /// This deletes a boat from the database
  Future<void> deleteBoat(Boat boat) async {
    await _boatDao.deleteBoat(boat);
  }

  /// This updates a boat that already exists
  Future<int> updateBoat(Boat boat) async {
    return await _boatDao.updateBoat(boat);
  }

  /// This saves a new boat and remembers it for copying later
  Future<void> saveBoat(Boat boat) async {
    await _boatDao.insertBoat(boat);
    
    await BoatPrefs.saveLastBoat({
      "address": boat.address,
      "price": boat.price,
      "powerType": boat.powerType,
      "boatLength": boat.boatLength,
      "yearBuilt": boat.yearBuilt,
    });
  }

  /// This loads the last boat you saved so you can copy it
  Future<Boat?> loadLastBoat() async {
    /// Get the saved boat data
    final data = await BoatPrefs.loadLastBoat();
    
    /// If there is no saved boat, return nothing
    if (data == null) {
      return null;
    }
    
    /// Create a boat object from the saved data
    final boat = Boat(
      address: data['address'] ?? "",
      price: data['price'] ?? "",
      powerType: data['powerType'] ?? "",
      boatLength: data['boatLength'] ?? "",
      yearBuilt: data['yearBuilt'] ?? "",
    );
    
    return boat;
  }

  /// This checks if all boat fields are filled in
  bool validateFields(Boat boat) {
    /// Make a list of all the fields to check
    final fields = [
      boat.address,
      boat.price,
      boat.powerType,
      boat.boatLength,
      boat.yearBuilt
    ];
    
    /// Check each field to make sure it's not empty
    for (final field in fields) {
      if (field.isEmpty) return false;
    }
    
    return true;
  }
}

