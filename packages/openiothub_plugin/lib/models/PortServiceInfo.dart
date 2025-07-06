class PortServiceInfo {
  String addr;
  int port;
  String? runId;
  String? realAddr;
  dynamic data;
  bool isLocal;
  Map<String, String>? info;
  PortServiceInfo(this.addr, this.port, this.isLocal, {this.runId, this.realAddr, this.data, this.info});

  PortServiceInfo copyWith({String? addr, int? port, bool? isLocal, String? runId, String? realAddr, dynamic data, Map<String, String>? info}) {
    return PortServiceInfo(
      addr ?? this.addr,
      port ?? this.port,
      isLocal ?? this.isLocal,
      runId: runId ?? this.runId,
      realAddr: realAddr ?? this.realAddr,
      data: data ?? this.data,
      info: info ?? this.info,
    );
  }
}