import 'package:openiothub/plugins/registry/plugin_registry.dart';

/// 长期由「内置模块 / 第三方扩展包」实现，在启动时向 [PluginRegistry] 登记页面。
///
/// 应用侧可维护 [List<OpenIoTHubPluginModule>]，按需启用、排序或做动态加载。
abstract interface class OpenIoTHubPluginModule {
  /// 模块稳定标识（日志、配置键）；勿与具体设备 [OpenIoTHubPluginDefinition.id] 混淆。
  String get moduleId;

  /// 将本模块提供的插件注册到 [registry]。
  void registerInto(PluginRegistry registry);
}

extension OpenIoTHubPluginRegistryModules on PluginRegistry {
  /// 依次调用各模块的 [OpenIoTHubPluginModule.registerInto]（顺序即注册顺序）。
  void registerModules(Iterable<OpenIoTHubPluginModule> modules) {
    for (final m in modules) {
      m.registerInto(this);
    }
  }
}
