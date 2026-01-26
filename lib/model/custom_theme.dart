import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openiothub/utils/theme_utils.dart';

/// 主题模式枚举
enum AppThemeMode {
  /// 自动模式，跟随系统设置
  automatic,
  /// 浅色模式
  light,
  /// 深色模式
  dark;

  /// 从字符串转换为枚举
  static AppThemeMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'automatic':
        return AppThemeMode.automatic;
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.automatic;
    }
  }

  /// 转换为字符串（用于持久化）
  String toValue() {
    switch (this) {
      case AppThemeMode.automatic:
        return 'automatic';
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
    }
  }

  /// 转换为 Flutter 的 ThemeMode
  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.automatic:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

/// SharedPreferences 键名常量
class _ThemeKeys {
  // 使用旧的键名以保持向后兼容性
  static const String themeMode = 'theme'; // 保持与旧代码兼容
  static const String themeColor = 'theme_color';
}

/// 自定义主题管理器
/// 
/// 负责管理应用的主题模式（浅色/深色/自动）和主题颜色
/// 使用 ChangeNotifier 实现状态管理，支持 Provider 模式
class CustomTheme with ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.automatic;
  Color _primaryColor = ThemeUtils.defaultColor;
  bool _isInitialized = false;

  /// 是否已初始化
  bool get isInitialized => _isInitialized;

  /// 当前主题模式
  AppThemeMode get themeMode => _themeMode;

  /// 当前主题颜色
  Color get primaryColor => _primaryColor;

  /// 当前主题模式对应的字符串值（向后兼容）
  @Deprecated('使用 themeMode 代替')
  String get themeValue => _themeMode.toValue();

  /// 构造函数
  /// 
  /// 注意：初始化是异步的，使用 [initialize] 方法确保数据已加载
  CustomTheme() {
    _initialize();
  }

  /// 异步初始化主题数据
  /// 
  /// 从 SharedPreferences 加载保存的主题模式和颜色
  Future<void> initialize() async {
    if (_isInitialized) return;
    await _loadThemeData();
  }

  /// 内部初始化方法
  Future<void> _initialize() async {
    try {
      await _loadThemeData();
    } catch (e) {
      // 初始化失败时使用默认值
      debugPrint('Failed to initialize theme: $e');
    }
  }

  /// 从 SharedPreferences 加载主题数据
  Future<void> _loadThemeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 加载主题模式
      final themeModeString = prefs.getString(_ThemeKeys.themeMode);
      if (themeModeString != null) {
        _themeMode = AppThemeMode.fromString(themeModeString);
      }
      
      // 加载主题颜色
      final colorValue = prefs.getInt(_ThemeKeys.themeColor);
      if (colorValue != null) {
        _primaryColor = Color(colorValue);
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme data: $e');
      _isInitialized = true; // 即使失败也标记为已初始化，使用默认值
    }
  }

  /// 设置主题模式
  /// 
  /// [mode] 要设置的主题模式
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _themeMode = mode;
      await prefs.setString(_ThemeKeys.themeMode, mode.toValue());
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting theme mode: $e');
      rethrow;
    }
  }

  /// 设置主题模式（字符串形式，向后兼容）
  /// 
  /// [value] 主题模式字符串：'automatic', 'light', 或 'dark'
  @Deprecated('使用 setThemeMode(AppThemeMode) 代替')
  Future<void> setThemeValue(String value) async {
    await setThemeMode(AppThemeMode.fromString(value));
  }

  /// 设置主题颜色
  /// 
  /// [color] 要设置的主题颜色
  Future<void> setThemeColor(Color color) async {
    if (_primaryColor == color) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _primaryColor = color;
      await prefs.setInt(_ThemeKeys.themeColor, color.value);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting theme color: $e');
      rethrow;
    }
  }

  /// 设置主题颜色（直接设置，不持久化）
  /// 
  /// 注意：此方法不会保存到 SharedPreferences，仅用于临时设置
  /// 使用 [setThemeColor] 来持久化设置
  set primaryColor(Color color) {
    if (_primaryColor == color) return;
    _primaryColor = color;
    notifyListeners();
  }

  /// 获取当前主题模式对应的 ThemeMode
  ThemeMode getThemeMode() {
    return _themeMode.toThemeMode();
  }

  /// 判断当前是否为浅色主题
  /// 
  /// 如果主题模式为自动，则根据系统设置判断
  bool isLightTheme() {
    switch (_themeMode) {
      case AppThemeMode.automatic:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.light;
      case AppThemeMode.light:
        return true;
      case AppThemeMode.dark:
        return false;
    }
  }

  /// 获取主题值（向后兼容方法）
  /// 
  /// 从 SharedPreferences 读取，如果不存在则返回当前值
  @Deprecated('使用 themeMode 属性代替')
  Future<String> getThemeValue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeValuePrefs = prefs.getString(_ThemeKeys.themeMode);
      return themeValuePrefs ?? _themeMode.toValue();
    } catch (e) {
      debugPrint('Error getting theme value: $e');
      return _themeMode.toValue();
    }
  }
}

/// 主题数据生成器
/// 
/// 提供静态方法用于生成浅色和深色主题数据
class CustomThemes {
  /// 获取浅色主题
  /// 
  /// [primaryColor] 主题的主色调
  static ThemeData getLightTheme(Color primaryColor) {
    return ThemeData(
      useMaterial3: false, // 保持 Material 2 风格
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(primaryColor),
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor,
      ),
      iconTheme: IconThemeData(color: primaryColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// 获取深色主题
  /// 
  /// [primaryColor] 主题的主色调
  static ThemeData getDarkTheme(Color primaryColor) {
    const Color darkSurfaceColor = Color(0xFF121212);
    const Color darkAccentColor = Color(0xFF1E1E1E);
    
    return ThemeData(
      useMaterial3: false, // 保持 Material 2 风格
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(primaryColor),
      primaryColor: darkAccentColor,
      scaffoldBackgroundColor: darkSurfaceColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: darkSurfaceColor,
      ),
      iconTheme: IconThemeData(color: primaryColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: darkAccentColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkAccentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: darkAccentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// 将 Color 转换为 MaterialColor
  /// 
  /// 生成包含不同深浅度的 MaterialColor，用于 Material Design 组件
  /// [color] 基础颜色
  static MaterialColor _createMaterialColor(Color color) {
    final List<double> strengths = <double>[0.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    // 生成不同强度的颜色
    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
