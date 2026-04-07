import 'package:flutter/widgets.dart';
import 'package:openiothub/plugin/models/port_service_info.dart';
import 'package:openiothub/plugin/registry/plugin_context.dart';

typedef PluginPageBuilder = Widget Function(PluginContext context);

/// 设备 / 服务插件页面注册表，可通过 [Provider] 注入，并在运行时增删。
class PluginRegistry extends ChangeNotifier {
  final Map<String, PluginPageBuilder> _builders = {};

  /// 已注册的 model id（可用于调试或设置页展示）。
  Iterable<String> get registeredModelIds => _builders.keys;

  int get length => _builders.length;

  bool supports(String? modelId) =>
      modelId != null && modelId.isNotEmpty && _builders.containsKey(modelId);

  /// 注册插件页构建函数。[allowOverride] 为 false 且已存在同 id 时会抛出。
  void register(
    String modelId,
    PluginPageBuilder builder, {
    bool allowOverride = true,
  }) {
    if (!allowOverride && _builders.containsKey(modelId)) {
      throw StateError('Plugin already registered: $modelId');
    }
    _builders[modelId] = builder;
    notifyListeners();
  }

  void registerAll(
    Map<String, PluginPageBuilder> entries, {
    bool allowOverride = true,
  }) {
    registerBatch(entries, allowOverride: allowOverride);
  }

  /// 批量注册，结束时只 [notifyListeners] 一次（适合启动时注册大量内置插件）。
  void registerBatch(
    Map<String, PluginPageBuilder> entries, {
    bool allowOverride = true,
  }) {
    if (entries.isEmpty) return;
    for (final e in entries.entries) {
      if (!allowOverride && _builders.containsKey(e.key)) {
        throw StateError('Plugin already registered: ${e.key}');
      }
      _builders[e.key] = e.value;
    }
    notifyListeners();
  }

  void unregister(String modelId) {
    if (_builders.remove(modelId) != null) {
      notifyListeners();
    }
  }

  /// 清空全部注册（例如测试或动态重载模块前）；有变更时通知监听者。
  void clear() {
    if (_builders.isEmpty) return;
    _builders.clear();
    notifyListeners();
  }

  /// 构建插件根 [Widget]；未知 [modelId] 时返回 null。
  Widget? tryBuildPage(String modelId, PortServiceInfo service) {
    final builder = _builders[modelId];
    if (builder == null) return null;
    return builder(PluginContext(modelId: modelId, service: service));
  }

  /// 与 [tryBuildPage] 相同，但在未注册时抛出。
  Widget buildPage(String modelId, PortServiceInfo service) {
    final w = tryBuildPage(modelId, service);
    if (w == null) {
      throw StateError('No plugin registered for model: $modelId');
    }
    return w;
  }
}
