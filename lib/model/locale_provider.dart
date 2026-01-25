import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  static const String _localeKey = 'app_locale';

  LocaleProvider() {
    _loadLocale();
  }

  Locale? get locale => _locale;

  Future<void> loadLocale() async {
    await _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      final parts = localeCode.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
      } else {
        _locale = Locale(parts[0]);
      }
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale != null) {
      await prefs.setString(_localeKey, locale.toString());
    } else {
      await prefs.remove(_localeKey);
    }
    notifyListeners();
  }

  Locale getEffectiveLocale(Locale systemLocale) {
    return _locale ?? systemLocale;
  }
}
