import 'package:flutter/material.dart';

/// 插件页 [MaterialPageRoute] 的共用选项，便于全应用统一全屏对话框、状态保持、路由名（深链 / 分析）等。
@immutable
class PluginRouteSettings {
  const PluginRouteSettings({
    this.fullscreenDialog = false,
    this.maintainState = true,
    this.routeSettings,
  });

  /// 带 [RouteSettings.name] / [RouteSettings.arguments]，便于 GoRouter 以外场景的埋点与 `Navigator.pop` 传参约定。
  factory PluginRouteSettings.withName(
    String name, {
    Object? arguments,
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    return PluginRouteSettings(
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
      routeSettings: RouteSettings(name: name, arguments: arguments),
    );
  }

  final bool fullscreenDialog;
  final bool maintainState;

  /// 传入 [Navigator] 的 [RouteSettings]（如 `name`、`arguments`），便于统一深链与埋点。
  final RouteSettings? routeSettings;

  MaterialPageRoute<T> materialRoute<T>(Widget page) {
    return MaterialPageRoute<T>(
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
      settings: routeSettings,
      builder: (_) => page,
    );
  }
}
