import '../../model/portService.dart';
import './components.dart';

class ModelsMap {
  static Map<String, dynamic> modelsMap = Map.from({
    OneKeySwitchPage.modelName: (PortService device) {
//      简单的单按钮开关
      return OneKeySwitchPage(
        device: device,
      );
    },
//    斐讯DC1插排
    PhicommDC1PluginPage.modelName: (PortService device) {
      return PhicommDC1PluginPage(
        device: device,
      );
    },
//    DHT11,DTH22系列传感器
    DHTPage.modelName: (PortService device) {
      return DHTPage(
        device: device,
      );
    },
    //    光照强度传感器
    LightLevelPage.modelName: (PortService device) {
      return LightLevelPage(
        device: device,
      );
    },
    //    RGBA LED控制器
    RGBALedPage.modelName: (PortService device) {
      return RGBALedPage(
        device: device,
      );
    },
    //    串口315,433无线发射遥控器实现开门和关门
    Serial315433Page.modelName: (PortService device) {
      return Serial315433Page(
        device: device,
      );
    },
    //    串口转TCP
    UART2TCPPage.modelName: (PortService device) {
      return UART2TCPPage(
        device: device,
      );
    },

    //
    //    webDAV
    WebDAVPage.modelName: (PortService serviceInfo) {
      return WebDAVPage(
        serviceInfo: serviceInfo,
      );
    },
  });
}
