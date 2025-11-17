
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class CustomerPrefs {
  static final _prefs = EncryptedSharedPreferences();

  static Future<void> saveLastCustomer(Map<String, String> data) async {
    await _prefs.setString('last_customer', data.toString());
  }

  static Future<Map<String, String>?> loadLastCustomer() async {
    String? saved = await _prefs.getString('last_customer');
    if (saved == null) return null;
    saved = saved.replaceAll(RegExp(r'[\{\}]'), '');
    Map<String, String> map = {};
    for (var pair in saved.split(', ')) {
      var items = pair.split(': ');
      map[items[0]] = items[1];
    }
    return map;
  }

}