import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_plugin/models/PortServiceInfo.dart';

PortServiceInfo portConfig2portService(PortConfig portConfig) {
  Map<String,String> info = Map();
  var portServiceInfo = PortServiceInfo(
    // 设备的实际地址
    Config.webgRpcIp,
    portConfig.localProt,
    // 如果不是本网设备（是远程设备）则 使用的ip为127.0.0.1
    false,
    // TODO 能不能直接使用mDNSInfo
    info:info,
    runId: portConfig.device.runId,
    realAddr: portConfig.device.addr
  );
  return portServiceInfo;
}

PortServiceInfo portService2PortServiceInfo(PortService portService) {
  Map<String,String> info = Map();
  info.addAll(portService.info);
  var portServiceInfo = PortServiceInfo(
    // 设备的实际地址
      portService.ip,
      portService.port,
      // 如果不是本网设备（是远程设备）则 使用的ip为127.0.0.1
      portService.isLocal,
      // TODO 能不能直接使用mDNSInfo
      info:info,
      // realAddr: portService.ip
  );
  return portServiceInfo;
}