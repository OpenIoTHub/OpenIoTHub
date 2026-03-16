import 'package:flutter/material.dart';

class ThemeUtils {
  static const Color defaultColor = Colors.orange;

  static const Color lightGrey = Color(0xFFBDBDBD);

  static const List<Color> supportColors = [
    defaultColor,
    Colors.purple,
    Colors.deepPurpleAccent,
    Colors.redAccent,
    Colors.lightBlue,
    Colors.amber,
    Colors.green,
    Colors.lime,
    Colors.indigo,
    Colors.cyan,
    Colors.teal,
    lightGrey,
  ];

  static Color currentColorTheme = defaultColor;

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
