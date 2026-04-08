class PortServiceInfo {
  String addr;
  int port;
  String? runId;
  String? realAddr;
  dynamic data;
  bool isLocal;
  Map<String, String>? info;

  PortServiceInfo(
    this.addr,
    this.port,
    this.isLocal, {
    this.runId,
    this.realAddr,
    this.data,
    this.info,
  });

  PortServiceInfo copyWith({
    String? addr,
    int? port,
    bool? isLocal,
    String? runId,
    String? realAddr,
    dynamic data,
    Map<String, String>? info,
  }) {
    final Map<String, String> merged = {};
    if (info != null) {
      merged.addAll(info);
    } else if (this.info != null) {
      merged.addAll(this.info!);
    }
    return PortServiceInfo(
      addr ?? this.addr,
      port ?? this.port,
      isLocal ?? this.isLocal,
      runId: runId ?? this.runId,
      realAddr: realAddr ?? this.realAddr,
      data: data ?? this.data,
      info: merged,
    );
  }
}

/// 与 [PluginRegistry] 配合使用的常用元数据访问（避免魔法字符串散落）。
extension PortServiceInfoPluginX on PortServiceInfo {
  /// mDNS / 远程列表中的设备 model，对应注册表 key。
  /// 与 `package:openiothub/plugins/registry/plugin_invoke_request.dart` 中的 `pluginInvokeFromModel` 扩展配套使用。
  String? get pluginModelId => info?['model'];

  /// 展示名称（若存在）。
  String? get pluginDisplayName => info?['name'];
}
