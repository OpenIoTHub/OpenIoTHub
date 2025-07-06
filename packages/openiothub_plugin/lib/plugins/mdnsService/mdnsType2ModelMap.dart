import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';

import '../../models/PortServiceInfo.dart';
import './components.dart';

//兼容的mdns类型，最终的落地点都在ModelsMap里
//没有的id和mac置空
class MDNS2ModelsMap {
  static final Map<String, String> baseInfo = {
    "name": "OpenIoTHub Entity",
    "model": WebPage.modelName,
    "mac": "",
    "id": "",
    "author": "Farry",
    "email": "newfarry@126.com",
    "home-page": "https://github.com/iotdevice",
    "firmware-respository": "https://github.com/iotdevice/*",
    "firmware-version": "version",
  };

  static PortServiceInfo get basePortService {
    PortServiceInfo portServiceInfo = PortServiceInfo("127.0.0.1", 80, true, info: Map());
    portServiceInfo.isLocal = true;
    portServiceInfo.addr = "127.0.0.1";
    portServiceInfo.port = 80;
    portServiceInfo.info = Map();
    portServiceInfo.info!.addAll(baseInfo);
    return portServiceInfo;
  }

  //从ios14开始mdns发现的类型需要在Info.plist注册才可以被发现
  //	https://github.com/OpenIoTHub/OpenIoTHub/blob/41b1869951691a9084c66501b3d267daa4216577/ios/Runner/Info.plist#L38
  //请新模型的开发者同步在上述OpenIoTHub中的Info.plist添加新的mdns类型，如：_http._tcp
  //TODO：后续将会自动添加到Info.plist
  static Map<String, PortServiceInfo> modelsMap = Map.from({
    //    OpenIoTHub网关模型
    Config.mdnsGatewayService:
        getPortServiceByNameModel("gateway-go", Gateway.modelName),
    //    web UI,http使用web方式打开服务的模型
    "_http._tcp": getPortServiceByNameModel("Http service", WebPage.modelName),
    //    web UI,http使用web方式打开服务的模型
    "_CGI._tcp":
        getPortServiceByNameModel("CGI Http service", WebPage.modelName),
    //    web UI,homeassistant使用web方式打开服务的模型
    "_home-assistant._tcp":
        getPortServiceByNameModel("HomeAssistant", WebPage.modelName),
    // TODO
    "_ssh._tcp":
    getPortServiceByNameModel("SSH", SSHNativePage.modelName),
    "_casaos._tcp": getPortServiceByNameModel("casaos", WebPage.modelName),
    "_zimaos._tcp": getPortServiceByNameModel("zimaos", WebPage.modelName),
    // UPS
    // "_nut._tcp":
    // getPortServiceByNameModel("SSH", SSHWebPage.modelName),
    //    vnc远程桌面模型
    "_rfb._tcp": getPortServiceByNameModel(
        "VNC RFB remote desktop", VNCWebPage.modelName),
    // _device-info._tcp
  });

  static PortServiceInfo getPortServiceByNameModel(String name, model) {
    PortServiceInfo portServiceInfo = basePortService;
    portServiceInfo.info!["name"] = name;
    portServiceInfo.info!["model"] = model;
    return portServiceInfo;
  }

  static List<String> getAllmDnsServiceType() {
    List<String> keys = [Config.mdnsIoTDeviceService];
    keys.addAll(modelsMap.keys.toList());
    return keys;
  }

  static List<String> getAllmDnsType() {
    // 打印所有类型
    List<String> keys = getAllmDnsServiceType();
    keys.addAll({Config.mdnsTypeExplorer});
    return keys;
  }
}
