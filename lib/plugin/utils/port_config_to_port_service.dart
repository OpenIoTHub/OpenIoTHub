import 'package:openiothub/core/config.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub/plugin/models/port_service_info.dart';

/// 将 [PortConfig] 转为隧道侧访问用的 [PortServiceInfo]：
/// 地址/端口为本地 gRPC 与映射端口，[PortServiceInfo.info] 合并 [PortConfig.mDNSInfo]（model、name 等）。
PortServiceInfo portConfig2portService(PortConfig portConfig) {
  final Map<String, String> info = Map<String, String>.from(
    portConfig.mDNSInfo.info,
  );
  return PortServiceInfo(
    Config.webgRpcIp,
    portConfig.localProt,
    false,
    info: info,
    runId: portConfig.device.runId,
    realAddr: portConfig.device.addr,
  );
}

PortServiceInfo portService2PortServiceInfo(PortService portService) {
  final Map<String, String> info = {};
  info.addAll(portService.info);
  var portServiceInfo = PortServiceInfo(
    portService.ip,
    portService.port,
    portService.isLocal,
    info: info,
  );
  return portServiceInfo;
}
