import 'package:openiothub_constants/constants/Config.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_plugin/models/PortServiceInfo.dart';

PortServiceInfo portConfig2portService(PortConfig portConfig) {
  Map<String,String> info = Map();
  var portServiceInfo = PortServiceInfo(
    Config.webgRpcIp,
    portConfig.localProt,
    false,
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
      portService.ip,
      portService.port,
      portService.isLocal,
      info:info,
  );
  return portServiceInfo;
}
