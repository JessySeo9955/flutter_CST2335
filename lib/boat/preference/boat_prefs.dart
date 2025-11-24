import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// A utility class for saving and loading the most recently used boat data
/// using `EncryptedSharedPreferences`.
class BoatPrefs {
  /// The internal encrypted shared preferences instance used for persistence.
  static final _prefs = EncryptedSharedPreferences();

  /// Saves the provided boat data to encrypted storage.
  static Future<void> saveLastBoat(Map<String, String> data) async {
    await _prefs.setString('last_boat', data.toString());
  }

  /// Loads the last saved boat data from encrypted storage.
  static Future<Map<String, String>?> loadLastBoat() async {
    String? saved = await _prefs.getString('last_boat');
    saved = saved.replaceAll(RegExp(r'[\{\}]'), '');
    Map<String, String> map = {};
    for (var pair in saved.split(', ')) {
      var items = pair.split(': ');
      map[items[0]] = items[1];
    }
    return map;
  }
}

