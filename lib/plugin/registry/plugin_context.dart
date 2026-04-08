import 'package:flutter/foundation.dart';
import 'package:openiothub/models/port_service_info.dart';

/// 打开插件页时的统一入参，便于后续扩展（网关、会话、附加路由参数等）
/// 而不改动各插件页面的构造函数。
@immutable
class PluginContext {
  const PluginContext({
    required this.modelId,
    required this.service,
  });

  /// [PortServiceInfo.info] 中解析出的 model，与注册表 key 一致。
  final String modelId;

  /// 设备 / 服务连接信息（地址、端口、元数据等）。
  final PortServiceInfo service;

  /// 与 [service] 同义，便于注册闭包内与现有插件命名一致。
  PortServiceInfo get device => service;
}
