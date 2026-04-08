/// 历史文件：设备 / 服务插件页面注册已迁移到 [PluginRegistry]（通过 [Provider] 注入）。
///
/// - 注册入口：[registerBuiltinPlugins]（内部调用 [registerBuiltinDevicePlugins]、[registerBuiltinServicePlugins]）
/// - 打开设备页：`context.openPortServicePluginPage(device, onReturn: ...)`；已知 model：`pushPluginPage` / `pushPluginPageResult<T>` / `pluginRoute<T>`
/// - 运行时增删：`context.read<PluginRegistry>().register(...)`
library;

export 'package:openiothub/plugin/registry/builtin_plugins.dart';
export 'package:openiothub/plugin/registry/builtin_device_plugins.dart';
export 'package:openiothub/plugin/registry/builtin_service_plugins.dart';
export 'package:openiothub/plugin/registry/plugin_context.dart';
export 'package:openiothub/plugin/registry/plugin_navigation.dart';
export 'package:openiothub/plugin/registry/plugin_registry.dart';
