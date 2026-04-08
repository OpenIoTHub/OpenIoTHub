import 'package:flutter/material.dart';
import 'package:openiothub/models/port_service_info.dart';
import 'package:openiothub/plugins/registry/plugin_invoke_request.dart';
import 'package:openiothub/plugins/registry/plugin_registry.dart';
import 'package:openiothub/plugins/registry/plugin_route_settings.dart';
import 'package:openiothub/router/core/app_navigator.dart';
import 'package:provider/provider.dart';

/// 与 [PluginRegistry] 配合的导航，避免各处重复 `supports` / `buildPage` 逻辑。
extension PortServicePluginNavigation on BuildContext {
  /// 当前树上由 [Provider] 注入的 [PluginRegistry]（需在 `MaterialApp` / `MultiProvider` 之上使用）。
  PluginRegistry get pluginRegistry => read<PluginRegistry>();

  /// 注册表是否支持该插件 id 或已登记的别名。
  bool isPluginRegistered(String pluginId) => pluginRegistry.supports(pluginId);

  /// 是否支持该次调用所解析的 [PluginInvokeRequest.pluginId]（不校验参数是否满足插件实现）。
  bool isPluginInvokeSupported(PluginInvokeRequest request) =>
      pluginRegistry.supportsInvoke(request);

  /// [isPluginInvokeSupported] 且 [PluginRegistry.invokeParamsSatisfied]（与元数据定义一致）。
  bool isPluginInvokeParamsSatisfied(PluginInvokeRequest request) =>
      pluginRegistry.invokeParamsSatisfied(request);

  /// 按 [modelId] push 已注册插件根页；未注册返回 `false`（不弹路由）。
  ///
  /// 返回值表示是否**成功发起** push，与子页面 [Navigator.pop] 是否带返回值无关。
  ///
  /// [ensureInvokeParams] 为 true 时，先校验 [PluginRegistry.invokeParamsSatisfied]，不通过则直接返回 `false`。
  Future<bool> pushPluginPage(
    String modelId,
    PortServiceInfo service, {
    PluginRouteSettings routeSettings = const PluginRouteSettings(),
    bool ensureInvokeParams = false,
  }) async {
    return pushPluginInvoke(
      PluginInvokeRequest.withService(modelId, service),
      routeSettings: routeSettings,
      ensureInvokeParams: ensureInvokeParams,
    );
  }

  /// 工具类插件：仅 id + [extras]（无 [PortServiceInfo]），等价于 [pushPluginInvoke] + [PluginInvokeRequest.utility]。
  Future<bool> pushUtilityPluginInvoke(
    String pluginId, {
    Map<String, Object?> extras = const {},
    PluginRouteSettings routeSettings = const PluginRouteSettings(),
    bool ensureInvokeParams = false,
  }) {
    return pushPluginInvoke(
      PluginInvokeRequest.utility(pluginId, extras),
      routeSettings: routeSettings,
      ensureInvokeParams: ensureInvokeParams,
    );
  }

  /// 按 [PluginInvokeRequest]（插件 id 或别名 + 参数）push 插件根页。
  Future<bool> pushPluginInvoke(
    PluginInvokeRequest request, {
    PluginRouteSettings routeSettings = const PluginRouteSettings(),
    bool ensureInvokeParams = false,
  }) async {
    final page = pluginRegistry.tryInvoke(
      request,
      requireInvokeParamsSatisfied: ensureInvokeParams,
    );
    if (page == null) return false;
    await Navigator.of(this).push<void>(
      routeSettings.materialRoute<void>(page),
    );
    return true;
  }

  /// Push 插件根页并等待关闭；未注册时 Future 立即完成且值为 `null`。
  ///
  /// 若已注册，Future 完成值为子路由 [Navigator.pop] 传入的结果（未传参则为 `null`）。
  Future<T?> pushPluginPageResult<T>(
    String modelId,
    PortServiceInfo service, {
    PluginRouteSettings routeSettings = const PluginRouteSettings(),
    bool ensureInvokeParams = false,
  }) {
    return pushPluginInvokeResult<T>(
      PluginInvokeRequest.withService(modelId, service),
      routeSettings: routeSettings,
      ensureInvokeParams: ensureInvokeParams,
    );
  }

  Future<T?> pushPluginInvokeResult<T>(
    PluginInvokeRequest request, {
    PluginRouteSettings routeSettings = const PluginRouteSettings(),
    bool ensureInvokeParams = false,
  }) {
    final page = pluginRegistry.tryInvoke(
      request,
      requireInvokeParamsSatisfied: ensureInvokeParams,
    );
    if (page == null) {
      return Future<T?>.value();
    }
    return Navigator.of(this).push<T>(
      routeSettings.materialRoute<T>(page),
    );
  }

  /// 构建插件对应的 [Route]，未注册时返回 `null`。
  Route<T>? pluginRoute<T>(
    String modelId,
    PortServiceInfo service, {
    PluginRouteSettings routeSettings = const PluginRouteSettings(),
    bool ensureInvokeParams = false,
  }) {
    return pluginRouteFromInvoke<T>(
      PluginInvokeRequest.withService(modelId, service),
      routeSettings: routeSettings,
      ensureInvokeParams: ensureInvokeParams,
    );
  }

  Route<T>? pluginRouteFromInvoke<T>(
    PluginInvokeRequest request, {
    PluginRouteSettings routeSettings = const PluginRouteSettings(),
    bool ensureInvokeParams = false,
  }) {
    final page = pluginRegistry.tryInvoke(
      request,
      requireInvokeParamsSatisfied: ensureInvokeParams,
    );
    if (page == null) return null;
    return routeSettings.materialRoute<T>(page);
  }

  /// 若注册表支持 [device] 的 model，则 push 插件根页；否则打开通用设备信息页。
  ///
  /// [onReturn] 在子路由关闭后调用（插件页或信息页任一路径），便于列表页刷新。
  ///
  /// 默认 [ensureInvokeParams] 为 true，在 push 前校验 [PluginRegistry.invokeParamsSatisfied]；
  /// 若需与旧行为完全一致可设为 false。
  Future<void> openPortServicePluginPage(
    PortServiceInfo device, {
    Future<void> Function()? onReturn,
    PluginRouteSettings routeSettings = const PluginRouteSettings(),
    bool ensureInvokeParams = true,
  }) async {
    final request = device.pluginInvokeFromModel();
    if (request != null &&
        await pushPluginInvoke(
          request,
          routeSettings: routeSettings,
          ensureInvokeParams: ensureInvokeParams,
        )) {
      await onReturn?.call();
      return;
    }
    await AppNavigator.pushInfo(this, device);
    await onReturn?.call();
  }
}
