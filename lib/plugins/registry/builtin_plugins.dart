import 'package:openiothub/plugins/registry/builtin_device_plugins.dart';
import 'package:openiothub/plugins/registry/builtin_service_plugins.dart';
import 'package:openiothub/plugins/registry/openiothub_plugin_module.dart';
import 'package:openiothub/plugins/registry/plugin_registry.dart';

/// 默认内置插件模块列表；第三方可在应用层 `insert` / `add` 自己的 [OpenIoTHubPluginModule] 后再统一 [registerInto]。
const List<OpenIoTHubPluginModule> openIoTHubDefaultBuiltinPluginModules = [
  BuiltinDevicePluginsModule(),
  BuiltinServicePluginsModule(),
];

/// 内置设备类插件模块。
class BuiltinDevicePluginsModule implements OpenIoTHubPluginModule {
  const BuiltinDevicePluginsModule();

  @override
  String get moduleId => 'openiothub.builtin.device_plugins';

  @override
  void registerInto(PluginRegistry registry) {
    registerBuiltinDevicePlugins(registry);
  }
}

/// 内置服务类插件模块。
class BuiltinServicePluginsModule implements OpenIoTHubPluginModule {
  const BuiltinServicePluginsModule();

  @override
  String get moduleId => 'openiothub.builtin.service_plugins';

  @override
  void registerInto(PluginRegistry registry) {
    registerBuiltinServicePlugins(registry);
  }
}

/// 注册内置插件，并可选追加 [extraModules]（第三方、按配置启用的模块等）。
///
/// [registerBuiltinPlugins] 等价于 `registerOpenIoTHubPlugins(registry)`。
void registerOpenIoTHubPlugins(
  PluginRegistry registry, {
  Iterable<OpenIoTHubPluginModule> extraModules = const [],
}) {
  registry.registerModules([
    ...openIoTHubDefaultBuiltinPluginModules,
    ...extraModules,
  ]);
}

/// 注册应用内置的全部插件。应用启动时调用一次即可。
///
/// 需要同时加载扩展模块时请改用 [registerOpenIoTHubPlugins]。
void registerBuiltinPlugins(PluginRegistry registry) {
  registerOpenIoTHubPlugins(registry);
}
