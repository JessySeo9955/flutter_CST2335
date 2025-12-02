import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// This class saves boat information so you can copy it later
class BoatPrefs {
  /// This is where we save the boat data securely
  static final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();

  /// This loads the last boat you saved
  static Future<Map<String, String>?> loadLastBoat() async {
    /// Get the saved boat data from storage
    String? data = await _storage.getString('last_boat');
    
    /// Remove the curly brackets from the data
    final cleanedData = data.replaceAll(RegExp(r'[\{\}]'), '');
    /// Split the data into separate pieces
    final entries = cleanedData.split(', ');
    
    /// Create an empty map to hold the boat information
    Map<String, String> result = {};
    /// Go through each piece and add it to the map
    entries.forEach((entry) {
      final parts = entry.split(': ');
      if (parts.length == 2) {
        result[parts[0]] = parts[1];
      }
    });
    
    return result;
  }

  /// This saves the boat information for later use
  static Future<void> saveLastBoat(Map<String, String> boatData) async {
    await _storage.setString('last_boat', boatData.toString());
  }
}

