/// 与主应用 [AppRoutes] 一致的路由路径常量，供 common_pages 等包跳转时使用，避免硬编码字符串。
/// 主应用 `lib/router/core/app_routes.dart` 中对应常量应与此文件保持同步。
class RoutePaths {
  RoutePaths._();

  static const String languagePicker = '/language-picker';
  static const String themeColorPicker = '/theme-color-picker';
  static const String themeModePicker = '/theme-mode-picker';
}
