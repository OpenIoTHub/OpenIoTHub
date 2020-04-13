import '../../model/portService.dart';
import './components.dart';
//TODO：为每一个模型添加图标信息
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
    //    斐讯TC1插排
    PhicommTC1A1PluginPage.modelName: (PortService device) {
      return PhicommTC1A1PluginPage(
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
    //    web UI,使用web方式打开服务的模型
    WebPage.modelName: (PortService serviceInfo) {
      return WebPage(
        serviceInfo: serviceInfo,
      );
    },
    //    https://github.com/qlwz/esp_dc1 暂时使用web方式打开
    "com.94qing.devices.esp_dc1": (PortService serviceInfo) {
      return WebPage(
        serviceInfo: serviceInfo,
      );
    },
    //    webDAV文件
    WebDAVPage.modelName: (PortService serviceInfo) {
      return WebDAVPage(
        serviceInfo: serviceInfo,
      );
    },
    //    gateway网关
    Gateway.modelName: (PortService serviceInfo) {
      return Gateway(
        serviceInfo: serviceInfo,
      );
    },
  });
}
