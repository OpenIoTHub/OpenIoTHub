import 'package:flutter/material.dart';
import 'package:openiothub/plugin/models/port_service_info.dart';
import 'package:openiothub/plugin/registry/plugin_registry.dart';
import 'package:openiothub/router/app_navigator.dart';
import 'package:provider/provider.dart';

/// 与 [PluginRegistry] 配合的导航，避免各处重复 `supports` / `buildPage` 逻辑。
extension PortServicePluginNavigation on BuildContext {
  /// 按 [modelId] push 已注册插件根页；未注册返回 `false`（不弹路由）。
  ///
  /// 返回值表示是否**成功发起** push，与子页面 [Navigator.pop] 是否带返回值无关。
  Future<bool> pushPluginPage(String modelId, PortServiceInfo service) async {
    final page = read<PluginRegistry>().tryBuildPage(modelId, service);
    if (page == null) return false;
    await Navigator.of(this).push<void>(
      MaterialPageRoute<void>(builder: (_) => page),
    );
    return true;
  }

  /// Push 插件根页并等待关闭；未注册时 Future 立即完成且值为 `null`。
  ///
  /// 若已注册，Future 完成值为子路由 [Navigator.pop] 传入的结果（未传参则为 `null`）。
  Future<T?> pushPluginPageResult<T>(String modelId, PortServiceInfo service) {
    final page = read<PluginRegistry>().tryBuildPage(modelId, service);
    if (page == null) {
      return Future<T?>.value();
    }
    return Navigator.of(this).push<T>(
      MaterialPageRoute<T>(builder: (_) => page),
    );
  }

  /// 构建插件对应的 [Route]，未注册时返回 `null`。
  Route<T>? pluginRoute<T>(String modelId, PortServiceInfo service) {
    final page = read<PluginRegistry>().tryBuildPage(modelId, service);
    if (page == null) return null;
    return MaterialPageRoute<T>(builder: (_) => page);
  }

  /// 若注册表支持 [device] 的 model，则 push 插件根页；否则打开通用设备信息页。
  ///
  /// [onReturn] 在子路由关闭后调用（插件页或信息页任一路径），便于列表页刷新。
  Future<void> openPortServicePluginPage(
    PortServiceInfo device, {
    Future<void> Function()? onReturn,
  }) async {
    final modelId = device.pluginModelId;
    if (modelId != null && await pushPluginPage(modelId, device)) {
      await onReturn?.call();
      return;
    }
    await AppNavigator.pushInfo(this, device);
    await onReturn?.call();
  }
}
