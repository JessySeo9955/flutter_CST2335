import '../data/boat_dao.dart';
import '../data/boat_database.dart';
import '../data/boat_model.dart';
import '../preference/boat_prefs.dart';

// Service layer for boat operations
class BoatService {
  // Singleton instance
  static final BoatService _singleton = BoatService._privateConstructor();
  
  // Private constructor
  BoatService._privateConstructor();
  
  // Factory constructor returns singleton
  factory BoatService() => _singleton;

  // DAO instance for database access
  late BoatDao _boatDao;

  // Initialize database connection
  Future<void> init() async {
    final database = await $FloorBoatDatabase.databaseBuilder("boat.db").build();
    _boatDao = database.boatDao;
  }

  // Retrieve all boats from database
  Future<List<Boat>> getBoats() {
    return _boatDao.getAllBoats();
  }

  // Delete boat from database
  Future<void> deleteBoat(Boat boat) async {
    await _boatDao.deleteBoat(boat);
  }

  // Update existing boat in database
  Future<int> updateBoat(Boat boat) async {
    return await _boatDao.updateBoat(boat);
  }

  // Insert new boat and save to preferences
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

  // Load last saved boat from preferences
  Future<Boat?> loadLastBoat() async {
    final data = await BoatPrefs.loadLastBoat();
    
    if (data == null) {
      return null;
    }
    
    final boat = Boat(
      address: data['address'] ?? "",
      price: data['price'] ?? "",
      powerType: data['powerType'] ?? "",
      boatLength: data['boatLength'] ?? "",
      yearBuilt: data['yearBuilt'] ?? "",
    );
    
    return boat;
  }

  // Validate boat fields are not empty
  bool validateFields(Boat boat) {
    final fields = [
      boat.address,
      boat.price,
      boat.powerType,
      boat.boatLength,
      boat.yearBuilt
    ];
    
    for (final field in fields) {
      if (field.isEmpty) return false;
    }
    
    return true;
  }
}

