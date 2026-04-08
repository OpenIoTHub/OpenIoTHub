/// 历史文件：设备 / 服务插件页面注册已迁移到 [PluginRegistry]（通过 [Provider] 注入）。
///
/// - 注册入口：[registerOpenIoTHubPlugins]（扩展 [extraModules]）/ [registerBuiltinPlugins] / [openIoTHubDefaultBuiltinPluginModules] / [OpenIoTHubPluginRegistryModules.registerModules]；条目推荐 [PluginRegistry.registerPluginBatch] 与 [OpenIoTHubPluginDefinition]
/// - 打开设备页：`context.openPortServicePluginPage`（默认 `ensureInvokeParams: true`）；已知 id：`pushPluginPage` / [pushPluginInvoke]（可选 `ensureInvokeParams`）/ `pluginRoute<T>`
/// - 统一调用：[PluginInvokeRequest]、`PortServiceInfo` 的 [PortServiceInfoPluginInvokeX.pluginInvoke] + [PluginRegistry.tryInvoke]（可选 `requireInvokeParamsSatisfied`）；参数是否与元数据一致可查 [PluginRegistry.invokeParamsSatisfied] / [PortServicePluginNavigation.isPluginInvokeParamsSatisfied]
/// - 运行时增删：`registerPlugin` / `registerPluginBatch`；简易设备 `register` / `registerBatch`，服务 `registerServiceBatch`，工具 `registerUtilityBatch` / [PluginInvokeRequest.utility]
library;

export 'package:openiothub/plugins/registry/builtin_plugins.dart';
export 'package:openiothub/plugins/registry/builtin_device_plugins.dart';
export 'package:openiothub/plugins/registry/builtin_service_plugins.dart';
export 'package:openiothub/plugins/registry/openiothub_plugin_module.dart';
export 'package:openiothub/plugins/registry/openiothub_plugin_definition.dart';
export 'package:openiothub/plugins/registry/plugin_context.dart';
export 'package:openiothub/plugins/registry/plugin_invoke_request.dart';
export 'package:openiothub/plugins/registry/plugin_navigation.dart';
export 'package:openiothub/plugins/registry/plugin_registry.dart';
export 'package:openiothub/plugins/registry/plugin_registry_observer.dart';
export 'package:openiothub/plugins/registry/plugin_route_settings.dart';
