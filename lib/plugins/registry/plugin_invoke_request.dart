import 'package:flutter/foundation.dart';
import 'package:openiothub/models/port_service_info.dart';

/// 通过「插件 id + 参数表」调用插件时的标准请求。
///
/// 设备 / 服务类插件使用 [paramService] 传递隧道侧 [PortServiceInfo]；其它键进入 [PluginContext.extras]。
/// 工具类插件使用 [PluginInvokeRequest.utility]，无 [paramService] 时全部参数进入 [PluginContext.extras]。
@immutable
class PluginInvokeRequest {
  const PluginInvokeRequest({
    required this.pluginId,
    this.params = const {},
  });

  /// 插件 id 或已注册的别名。
  final String pluginId;

  /// 调用参数；至少应包含 [paramService]（设备 / 服务插件）。
  final Map<String, Object?> params;

  /// 标准参数名：[PortServiceInfo]，与列表、隧道、openPortService 等场景一致。
  static const String paramService = 'service';

  /// 从 [params] 取出 [PortServiceInfo]；缺省或类型错误时抛出 [ArgumentError]。
  PortServiceInfo requireService() {
    final Object? s = params[paramService];
    if (s is PortServiceInfo) {
      return s;
    }
    throw ArgumentError(
      'Plugin "$pluginId" requires params["$paramService"] of type PortServiceInfo.',
    );
  }

  /// [params] 中是否含有类型正确的 [PortServiceInfo]（[paramService]）。
  bool get hasTunnelServiceParam =>
      params[paramService] is PortServiceInfo;

  /// 供 [PluginContext] 使用：除 [paramService] 外的附加参数（浅拷贝）。
  Map<String, Object?> get extraParams {
    if (params.isEmpty) return const {};
    final out = Map<String, Object?>.from(params);
    out.remove(paramService);
    return out;
  }

  /// 设备 / 服务列表场景：仅 id + [PortServiceInfo]。
  factory PluginInvokeRequest.withService(
    String pluginId,
    PortServiceInfo service,
    [Map<String, Object?> extra = const {}]) {
    return PluginInvokeRequest(
      pluginId: pluginId,
      params: {
        paramService: service,
        ...extra,
      },
    );
  }

  /// 工具类插件：不包含 [paramService]，[params] 全部进入 [PluginContext.extras]。
  factory PluginInvokeRequest.utility(
    String pluginId, [
    Map<String, Object?> params = const {},
  ]) {
    return PluginInvokeRequest(pluginId: pluginId, params: params);
  }

  /// 覆盖 [pluginId] / [params]；未传入的字段沿用当前值。
  PluginInvokeRequest copyWith({
    String? pluginId,
    Map<String, Object?>? params,
  }) {
    return PluginInvokeRequest(
      pluginId: pluginId ?? this.pluginId,
      params: params != null
          ? Map<String, Object?>.from(params)
          : Map<String, Object?>.from(this.params),
    );
  }

  /// 在现有 [params] 上合并 [extra]（后者覆盖同名键）。
  PluginInvokeRequest mergeParams(Map<String, Object?> extra) {
    if (extra.isEmpty) return this;
    return PluginInvokeRequest(
      pluginId: pluginId,
      params: {
        ...params,
        ...extra,
      },
    );
  }
}

/// 由隧道侧 [PortServiceInfo] 构造插件调用请求（避免 `models` 依赖插件包）。
extension PortServiceInfoPluginInvokeX on PortServiceInfo {
  /// 插件 id + 本服务；[extra] 进入 [PluginContext.extras]。
  PluginInvokeRequest pluginInvoke(
    String pluginId, [
    Map<String, Object?> extra = const {},
  ]) {
    return PluginInvokeRequest.withService(pluginId, this, extra);
  }

  /// 使用 [PortServiceInfoPluginX.pluginModelId]（`info['model']`）作为插件 id；
  /// 无 model 或为空时返回 `null`。
  PluginInvokeRequest? pluginInvokeFromModel() {
    final id = pluginModelId;
    if (id == null || id.isEmpty) {
      return null;
    }
    return PluginInvokeRequest.withService(id, this);
  }
}
