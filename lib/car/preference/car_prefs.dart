import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// Encrypted storage for the previously entered car details.
class CarPrefs {
  static final EncryptedSharedPreferences _prefs =
  EncryptedSharedPreferences();

  /// Saves the last entered car details.
  static Future<void> saveLastCar({
    required String year,
    required String make,
    required String model,
    required String price,
    required String kilometers,
  }) async {
    await _prefs.setString('car_last_year', year);
    await _prefs.setString('car_last_make', make);
    await _prefs.setString('car_last_model', model);
    await _prefs.setString('car_last_price', price);
    await _prefs.setString('car_last_km', kilometers);
  }

  /// Loads previously entered car details from encrypted storage.
  static Future<Map<String, String>?> loadLastCar() async {
    final year = await _prefs.getString('car_last_year');
    if (year == null || year.isEmpty) return null;

    return {
      'year': year,
      'make': await _prefs.getString('car_last_make') ?? '',
      'model': await _prefs.getString('car_last_model') ?? '',
      'price': await _prefs.getString('car_last_price') ?? '',
      'kilometers': await _prefs.getString('car_last_km') ?? '',
    };
  }
}
