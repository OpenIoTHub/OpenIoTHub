import 'package:openiothub/plugin/registry/builtin_device_plugins.dart';
import 'package:openiothub/plugin/registry/builtin_service_plugins.dart';
import 'package:openiothub/plugin/registry/plugin_registry.dart';

/// 注册应用内置的全部插件。应用启动时调用一次即可。
///
/// 设备类与服务类已拆到 [registerBuiltinDevicePlugins]、[registerBuiltinServicePlugins]，
/// 后续可增加 `registerThirdPartyPlugins` 等并在本函数中串联。
void registerBuiltinPlugins(PluginRegistry registry) {
  registerBuiltinDevicePlugins(registry);
  registerBuiltinServicePlugins(registry);
}
