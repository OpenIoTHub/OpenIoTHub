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
      return true;
    } else if (_themeValue == "light") {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getThemeValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeValuePrefs;
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
    accentColor: _lightAccentColor,
    accentColorBrightness: Brightness.dark,
    bottomAppBarTheme:
        BottomAppBarTheme(color: _lightAccentColor, elevation: 8.0),
    buttonColor: _lightAccentColor,
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    ),
    brightness: Brightness.light,
    cursorColor: _lightAccentColor,
    dialogBackgroundColor: Colors.white,
    indicatorColor: _lightAccentColor,
    inputDecorationTheme: InputDecorationTheme(
//      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
      contentPadding: EdgeInsets.all(14.0),
//      focusedBorder: OutlineInputBorder(
//        borderSide: BorderSide(color: _lightAccentColor, width: 2.0),
//        borderRadius: BorderRadius.circular(4.0),
//      ),
      labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
    ),
    primaryColor: _lightAccentColor,
    scaffoldBackgroundColor: Colors.white,
    textSelectionHandleColor: _lightAccentColor,
  );

  static final Color _darkAccentColor = Colors.black26;
  static final ThemeData dark = ThemeData(
    accentColor: _darkAccentColor,
    accentColorBrightness: Brightness.light,
    bottomAppBarColor: Color.fromRGBO(50, 50, 50, 1),
    bottomAppBarTheme: BottomAppBarTheme(elevation: 8.0),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    ),
    brightness: Brightness.dark,
    cursorColor: _darkAccentColor,
    dialogBackgroundColor: Color.fromRGBO(62, 62, 62, 1),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
      contentPadding: EdgeInsets.all(14.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkAccentColor, width: 2.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey[300]),
    ),
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Color.fromRGBO(22, 22, 22, 1),
    textSelectionHandleColor: _darkAccentColor,
  );
}
