import 'package:flutter/foundation.dart';

/// 内置 / 动态插件分类，便于设置页、文档与后续按类加载策略。
enum OpenIoTHubPluginCategory {
  /// 传感器、斐讯、MQTT 设备等。
  device,

  /// Web、网关、NAS、SSH、流媒体等。
  service,

  /// 不依赖隧道侧 [PortServiceInfo] 的扩展（预留）。
  utility,
}

/// 插件元数据：统一 [id]（主键）、可选别名与分类，供注册表与后续插件市场等使用。
@immutable
class OpenIoTHubPluginDefinition {
  const OpenIoTHubPluginDefinition({
    required this.id,
    this.displayName,
    this.category = OpenIoTHubPluginCategory.device,
    this.aliases = const [],
    this.description,
    this.semanticVersion,
    this.sortPriority = 0,
  });

  /// 设备类插件（内置注册常用，避免重复写 [OpenIoTHubPluginCategory.device]）。
  factory OpenIoTHubPluginDefinition.device(
    String id, {
    List<String> aliases = const [],
    String? displayName,
    String? description,
    String? semanticVersion,
    int sortPriority = 0,
  }) {
    return OpenIoTHubPluginDefinition(
      id: id,
      category: OpenIoTHubPluginCategory.device,
      aliases: aliases,
      displayName: displayName,
      description: description,
      semanticVersion: semanticVersion,
      sortPriority: sortPriority,
    );
  }

  /// 服务类插件（Web、网关、SSH 等）。
  factory OpenIoTHubPluginDefinition.service(
    String id, {
    List<String> aliases = const [],
    String? displayName,
    String? description,
    String? semanticVersion,
    int sortPriority = 0,
  }) {
    return OpenIoTHubPluginDefinition(
      id: id,
      category: OpenIoTHubPluginCategory.service,
      aliases: aliases,
      displayName: displayName,
      description: description,
      semanticVersion: semanticVersion,
      sortPriority: sortPriority,
    );
  }

  /// 工具类插件：不依赖隧道侧 [PortServiceInfo]，通过 [PluginInvokeRequest.utility] 与 [PluginContext.extras] 传参。
  factory OpenIoTHubPluginDefinition.utility(
    String id, {
    List<String> aliases = const [],
    String? displayName,
    String? description,
    String? semanticVersion,
    int sortPriority = 0,
  }) {
    return OpenIoTHubPluginDefinition(
      id: id,
      category: OpenIoTHubPluginCategory.utility,
      aliases: aliases,
      displayName: displayName,
      description: description,
      semanticVersion: semanticVersion,
      sortPriority: sortPriority,
    );
  }

  /// 规范插件 id，与设备 model、服务 model 或业务约定字符串一致；也是 [PluginRegistry] 的主键。
  final String id;

  /// 展示用名称（可选）。
  final String? displayName;

  final OpenIoTHubPluginCategory category;

  /// 与 [id] 指向同一实现的别名（历史 model 字符串等）。
  final List<String> aliases;

  final String? description;

  /// 语义化版本（如 `1.2.0`），供插件市场、兼容性校验预留。
  final String? semanticVersion;

  /// 列表 / 设置页排序权重，越大越靠前；默认 `0`。
  final int sortPriority;

  /// 设备 / 服务类为 true；工具类为 false（调用方不应依赖隧道 [PortServiceInfo]）。
  bool get expectsTunnelService =>
      category != OpenIoTHubPluginCategory.utility;

  /// 含主 id 与全部别名，用于内部注册多个 lookup key。
  Iterable<String> get allLookupKeys sync* {
    yield id;
    yield* aliases;
  }
}
