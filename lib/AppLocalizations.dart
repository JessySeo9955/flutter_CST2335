
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Provides localized string resources for the application.
class AppLocalizations {

  /// Creates an instance tied to the given [locale].
  AppLocalizations(this.locale){
    _localizedStrings = <String, String>{ };
  }

  /// Retrieves the nearest [AppLocalizations] instance in the widget tree.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// The delegate used by Flutter to load and manage localization resources.
  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  /// The locale for which translations will be loaded.
  final Locale locale;

  /// Holds all translation key–value pairs loaded from the JSON file.
  late Map<String, String> _localizedStrings;

  /// Loads the JSON translation file for the current locale.
  Future<void> load() async {

    String jsonString = await rootBundle.loadString('assets/translations/${locale.toString()}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  /// Returns the translated text associated with the given [key].
  String? translate(String key) {
    return _localizedStrings[key];
  }
}

/// A localization delegate responsible for creating and loading
/// [AppLocalizations] instances based on the device locale.
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  /// Creates a constant delegate instance.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}