import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeUtils {
  /// 移动端等默认主色（与主题色列表中的绿色一致）
  static const Color defaultColor = Colors.green;

  /// Windows / Fluent 常见强调蓝（约 #0078D4）
  static const Color windowsAccentBlue = Color(0xFF0078D4);

  /// macOS / iOS 风格系统蓝（约 #007AFF）
  static const Color macosSystemBlue = Color(0xFF007AFF);

  /// Linux 桌面常见 GTK/GNOME 强调蓝（约 #3584E4）
  static const Color linuxDesktopAccentBlue = Color(0xFF3584E4);

  static const Color lightGrey = Color(0xFFBDBDBD);

  /// 首次安装未保存主题色时的默认主色：桌面三端各用常见系统色，其余为 [defaultColor]。
  static Color get defaultPrimaryForCurrentPlatform {
    if (kIsWeb) return defaultColor;
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows => windowsAccentBlue,
      TargetPlatform.macOS => macosSystemBlue,
      TargetPlatform.linux => linuxDesktopAccentBlue,
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.fuchsia => defaultColor,
    };
  }

  /// 主题色选择器列表；首项为当前平台默认主色。
  static List<Color> get supportColors {
    final platformDefault = defaultPrimaryForCurrentPlatform;
    return [
      platformDefault,
      if (platformDefault != defaultColor) defaultColor,
      Colors.orange,
      Colors.purple,
      Colors.deepPurpleAccent,
      Colors.redAccent,
      Colors.lightBlue,
      Colors.amber,
      Colors.lime,
      Colors.indigo,
      Colors.cyan,
      Colors.teal,
      lightGrey,
    ];
  }

  static Color get currentColorTheme => defaultPrimaryForCurrentPlatform;

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
