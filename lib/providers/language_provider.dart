import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app's current locale and persists the user's choice between
/// sessions. Toggling FR/EN from any screen calls [toggleLocale].
class LanguageProvider extends ChangeNotifier {
  static const String _prefsKey = 'language_code';

  Locale _locale = const Locale('fr');

  /// The currently selected locale.
  Locale get locale => _locale;

  /// Sets the locale and persists it to [SharedPreferences].
  Future<void> setLocale(Locale locale) async {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }

  /// Switches between French and English.
  Future<void> toggleLocale() async {
    final Locale next =
        _locale.languageCode == 'fr' ? const Locale('en') : const Locale('fr');
    await setLocale(next);
  }

  /// Restores the saved language (called once at startup).
  Future<void> loadSavedLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_prefsKey);
    if (code != null && (code == 'en' || code == 'fr')) {
      _locale = Locale(code);
      notifyListeners();
    }
  }
}