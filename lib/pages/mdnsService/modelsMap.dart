import '../../model/portService.dart';
import './components.dart';

class ModelsMap {
  static Map<String, dynamic> modelsMap = Map.from({
    "com.iotserv.devices.one-key-switch": (PortService device) {
//      简单的单按钮开关
      return OneKeySwitchPage(
        device: device,
      );
    },
//    斐讯DC1插排
    "com.iotserv.devices.phicomm_dc1": (PortService device) {
      return PhicommDC1PluginPage(
        device: device,
      );
    },
//    DHT11,DTH22系列传感器
    "com.iotserv.devices.dht": (PortService device) {
      return DHTPage(
        device: device,
      );
    },
    //    光照强度传感器
    "com.iotserv.devices.lightLevel": (PortService device) {
      return LightLevelPage(
        device: device,
      );
    },
    //    RGBA LED控制器
    "com.iotserv.devices.rgbaLed": (PortService device) {
      return RGBALedPage(
        device: device,
      );
    },
    //    串口315,433无线发射遥控器实现开门和关门
    "com.iotserv.devices.serial-315-433": (PortService device) {
      return Serial315433Page(
        device: device,
      );
    },

    //
    //    webDAV
    "com.iotserv.devices.webdav": (PortService serviceInfo) {
      return WebDAVPage(
        serviceInfo: serviceInfo,
      );
    },
  });
}
