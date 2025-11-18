
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// A utility class for saving and loading the most recently used customer data
/// using `EncryptedSharedPreferences`.
class CustomerPrefs {
  /// The internal encrypted shared preferences instance used for persistence.
  static final _prefs = EncryptedSharedPreferences();

  /// Saves the provided customer data to encrypted storage.
  static Future<void> saveLastCustomer(Map<String, String> data) async {
    await _prefs.setString('last_customer', data.toString());
  }

  /// Loads the last saved customer data from encrypted storage.
  static Future<Map<String, String>?> loadLastCustomer() async {
    String? saved = await _prefs.getString('last_customer');
    saved = saved.replaceAll(RegExp(r'[\{\}]'), '');
    Map<String, String> map = {};
    for (var pair in saved.split(', ')) {
      var items = pair.split(': ');
      map[items[0]] = items[1];
    }
    return map;
  }

}