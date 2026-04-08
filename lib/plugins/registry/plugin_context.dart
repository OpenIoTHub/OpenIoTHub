import 'package:flutter/foundation.dart';
import 'package:openiothub/models/port_service_info.dart';
import 'package:openiothub/plugins/registry/plugin_invoke_request.dart';

/// 打开插件页时的统一入参，便于后续扩展（网关、会话、附加路由参数等）
/// 而不改动各插件页面的构造函数。
@immutable
class PluginContext {
  const PluginContext({
    required this.modelId,
    this.service,
    this.extras = const {},
  });

  /// 规范插件 id（与 [OpenIoTHubPluginDefinition.id] 一致）；若经别名打开，为**主 id**。
  final String modelId;

  /// 隧道侧设备 / 服务；[OpenIoTHubPluginCategory.utility] 等场景可为 null。
  final PortServiceInfo? service;

  /// 是否带有隧道侧 [PortServiceInfo]（即 [paramService] 已传入）。
  bool get hasTunnelService => service != null;

  /// 与历史命名一致；无 [service] 时抛出（工具类插件请用 [extras]）。
  PortServiceInfo get device {
    final s = service;
    if (s == null) {
      throw StateError(
        'PluginContext has no PortServiceInfo (utility plugin or missing paramService); '
        'modelId=$modelId',
      );
    }
    return s;
  }

  /// [PluginInvokeRequest] 中除 [PluginInvokeRequest.paramService] 外的参数。
  final Map<String, Object?> extras;

  /// 与 [modelId] 同义，强调「插件 id」语义。
  String get pluginId => modelId;

  /// 读取 [extras] 中键值并安全转为 [T]；类型不符或缺键时返回 null。
  T? extraAs<T>(String key) {
    final Object? v = extras[key];
    return v is T ? v : null;
  }

  factory PluginContext.fromInvoke(
    PluginInvokeRequest request, {
    required String resolvedPluginId,
  }) {
    final Object? s = request.params[PluginInvokeRequest.paramService];
    return PluginContext(
      modelId: resolvedPluginId,
      service: s is PortServiceInfo ? s : null,
      extras: request.extraParams,
    );
  }

  /// 复制并覆盖字段；[extras] 为 null 时沿用当前 [extras]。
  ///
  /// [mergeExtras] 为 true 时，将 [extras] 合并进当前表（后者覆盖同名键）。
  /// 将隧道 [service] 清空时请设 [clearTunnelService] 为 true。
  PluginContext copyWith({
    String? modelId,
    PortServiceInfo? service,
    Map<String, Object?>? extras,
    bool mergeExtras = false,
    bool clearTunnelService = false,
  }) {
    final Map<String, Object?> nextExtras;
    if (extras == null) {
      nextExtras = this.extras;
    } else if (mergeExtras) {
      nextExtras = {...this.extras, ...extras};
    } else {
      nextExtras = extras;
    }
    final PortServiceInfo? nextService;
    if (clearTunnelService) {
      nextService = null;
    } else if (service != null) {
      nextService = service;
    } else {
      nextService = this.service;
    }
    return PluginContext(
      modelId: modelId ?? this.modelId,
      service: nextService,
      extras: nextExtras,
    );
  }
}
