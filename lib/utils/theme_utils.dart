import 'package:flutter/material.dart';

class ThemeUtils {
  // 默认主题色
  static const Color defaultColor = Colors.blue;

  // 可选的主题色
  static const List<Color> supportColors = [
    defaultColor,
    Colors.purple,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.redAccent,
    Colors.blue,
    Colors.amber,
    Colors.green,
    Colors.lime,
    Colors.indigo,
    Colors.cyan,
    Colors.teal
  ];

  // 当前的主题色
  static Color currentColorTheme = defaultColor;

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
