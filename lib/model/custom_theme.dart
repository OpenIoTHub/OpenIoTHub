import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTheme with ChangeNotifier {
  String _themeValue = "automatic";

  set themeValue(String value) {
    _themeValue = value;
    notifyListeners();
  }

  String get themeValue => _themeValue;

  bool isLightTheme() {
    if (_themeValue == "automatic") {
      return window.platformBrightness == Brightness.light;
    } else if (_themeValue == "light") {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getThemeValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeValuePrefs;
    if (prefs != null) themeValuePrefs = prefs.getString("theme");
    return themeValuePrefs ?? themeValue;
  }

  Future<void> setThemeValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeValue = value;
    await prefs.setString("theme", value);
    notifyListeners();
  }
}

class CustomThemes {
  static final Color _lightAccentColor = Colors.orange;
  static final ThemeData light = ThemeData(
      brightness: Brightness.light,
      primarySwatch: _lightAccentColor as MaterialColor,
      primaryColor: _lightAccentColor);

  static final ThemeData dark = ThemeData(brightness: Brightness.dark);
}
