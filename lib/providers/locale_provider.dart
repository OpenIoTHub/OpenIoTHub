import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  static const String _localeKey = 'app_locale';
  
  // 支持的语言列表
  static const List<Locale> supportedLocales = [
    Locale('en'), // 英文
    Locale('zh'), // 简体中文
    Locale('zh', 'TW'), // 繁体中文
    Locale('ja'), // 日语
    Locale('ko'), // 韩语
    Locale('de'), // 德语
    Locale('es'), // 西班牙语
    Locale('fr'), // 法语
    Locale('it'), // 意大利语
    Locale('ru'), // 俄语
    Locale('ar'), // 阿拉伯语
  ];

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
    if (localeCode != null && localeCode.isNotEmpty) {
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
      // Locale.toString() 返回格式：ja 或 zh_TW，直接使用
      final localeString = locale.toString();
      await prefs.setString(_localeKey, localeString);
    } else {
      await prefs.remove(_localeKey);
    }
    notifyListeners();
  }

  /// 获取有效的语言环境
  /// 优先级：用户设置 > 系统语言（如果支持）> 英文
  Locale getEffectiveLocale(Locale systemLocale) {
    // 如果用户设置了语言，使用用户设置
    if (_locale != null) {
      return _locale!;
    }
    
    // 尝试匹配系统语言
    final matchedLocale = _findBestMatch(systemLocale);
    if (matchedLocale != null) {
      return matchedLocale;
    }
    
    // 默认返回英文
    return const Locale('en');
  }

  /// 在支持的语言列表中找到最佳匹配
  Locale? _findBestMatch(Locale systemLocale) {
    // 精确匹配（语言代码 + 国家代码）
    if (systemLocale.countryCode != null) {
      for (final locale in supportedLocales) {
        if (locale.languageCode == systemLocale.languageCode &&
            locale.countryCode == systemLocale.countryCode) {
          return locale;
        }
      }
    }
    
    // 语言代码匹配
    for (final locale in supportedLocales) {
      if (locale.languageCode == systemLocale.languageCode) {
        return locale;
      }
    }
    
    return null;
  }
}
