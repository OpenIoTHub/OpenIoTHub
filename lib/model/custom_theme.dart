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
    themeValuePrefs = prefs.getString("theme");
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
  static const Color _lightAccentColor = Colors.orange;
  static final ThemeData light = ThemeData(
      brightness: Brightness.light,
      primarySwatch: _lightAccentColor as MaterialColor,
      primaryColor: _lightAccentColor,
      // primaryColorLight: _lightAccentColor,
      iconTheme: const IconThemeData(color: _lightAccentColor),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: _lightAccentColor,
        unselectedItemColor: Colors.grey,
        // backgroundColor: Colors.white,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightAccentColor,
      ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: _lightAccentColor as MaterialColor,
    primaryColor: _lightAccentColor,
    // primaryColorLight: _lightAccentColor,
    iconTheme: const IconThemeData(color: _lightAccentColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _lightAccentColor,
      unselectedItemColor: Colors.grey,
      // backgroundColor: Colors.white,
    ),
  );
}
