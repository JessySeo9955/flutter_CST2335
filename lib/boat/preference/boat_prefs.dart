import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

// Handles encrypted preference storage for boat data
class BoatPrefs {
  static final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();

  // Load previously saved boat information
  static Future<Map<String, String>?> loadLastBoat() async {
    String? data = await _storage.getString('last_boat');
    
    final cleanedData = data.replaceAll(RegExp(r'[\{\}]'), '');
    final entries = cleanedData.split(', ');
    
    Map<String, String> result = {};
    entries.forEach((entry) {
      final parts = entry.split(': ');
      if (parts.length == 2) {
        result[parts[0]] = parts[1];
      }
    });
    
    return result;
  }

  // Save boat information to encrypted storage
  static Future<void> saveLastBoat(Map<String, String> boatData) async {
    await _storage.setString('last_boat', boatData.toString());
  }
}

