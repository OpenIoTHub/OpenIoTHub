import '../iotDeviceModel.dart';
import './devices.dart';

class ModelsMap {
  static Map<String, dynamic> modelsMap = Map.from({
    "com.iotserv.devices.one-key-switch": (IoTDevice device) {
//      简单的单按钮开关
      return OneKeySwitchPage(
        device: device,
      );
    },
//    斐讯DC1插排
    "com.iotserv.devices.phicomm_dc1": (IoTDevice device) {
      return PhicommDC1PluginPage(
        device: device,
      );
    },
//    DHT11,DTH22系列传感器
    "com.iotserv.devices.dht": (IoTDevice device) {
      return DHTPage(
        device: device,
      );
    },
    //    光照强度传感器
    "com.iotserv.devices.lightLevel": (IoTDevice device) {
      return LightLevelPage(
        device: device,
      );
    },
  });
}
