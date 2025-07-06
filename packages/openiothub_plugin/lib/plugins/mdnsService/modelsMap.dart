import 'package:flutter/cupertino.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';

import '../../models/PortServiceInfo.dart';
import './components.dart';
import 'mDNSService/ssh/SSHPage.dart';

//TODO：为每一个模型添加图标信息
class ModelsMap {
  static Map<String, dynamic> modelsMap = Map.from({
    OneKeySwitchPage.modelName: (PortServiceInfo device) {
//      简单的单按钮开关
      return OneKeySwitchPage(
        device: device,
        key: UniqueKey(),
      );
    },
//    斐讯DC1插排
    PhicommDC1PluginPage.modelName: (PortServiceInfo device) {
      return PhicommDC1PluginPage(
        device: device,
        key: UniqueKey(),
      );
    },
    //    斐讯TC1插排
    PhicommTC1A1PluginPage.modelName: (PortServiceInfo device) {
      return PhicommTC1A1PluginPage(
        device: device,
        key: UniqueKey(),
      );
    },
    //    斐讯TC1 A1   插排
    "com#iotserv#devices#phicomm_tc1_a1": (PortServiceInfo device) {
      return PhicommTC1A1PluginPage(
        device: device,
        key: UniqueKey(),
      );
    },
//    DHT11,DTH22系列传感器
    DHTPage.modelName: (PortServiceInfo device) {
      return DHTPage(
        device: device,
        key: UniqueKey(),
      );
    },
    //    光照强度传感器
    LightLevelPage.modelName: (PortServiceInfo device) {
      return LightLevelPage(
        device: device,
        key: UniqueKey(),
      );
    },
    //    RGBA LED控制器
    RGBALedPage.modelName: (PortServiceInfo device) {
      return RGBALedPage(
        device: device,
        key: UniqueKey(),
      );
    },
    //    串口315,433无线发射遥控器实现开门和关门
    Serial315433Page.modelName: (PortServiceInfo device) {
      return Serial315433Page(
        device: device,
        key: UniqueKey(),
      );
    },
    //    斐讯R1音箱
    PhicommR1ControlerPage.modelName: (PortServiceInfo device) {
      return PhicommR1ControlerPage(
        device: device,
        key: UniqueKey(),
      );
    },
    //    串口转TCP
    UART2TCPPage.modelName: (PortServiceInfo device) {
      return UART2TCPPage(
        device: device,
        key: UniqueKey(),
      );
    },

    //
    //    web UI,使用web方式打开服务的模型
    WebPage.modelName: (PortServiceInfo device) {
      return WebPage(
        device: device,
        key: UniqueKey(),
      );
    },
    //    https://github.com/qlwz/esp_dc1 暂时使用web方式打开
    "com.94qing.devices.esp_dc1": (PortServiceInfo device) {
      return WebPage(
        device: device,
        key: UniqueKey(),
      );
    },
    //    webDAV文件
    // WebDAVPage.modelName: (PortServiceInfo device) {
    //   return WebDAVPage(
    //     device: device,
    //   );
    // },
    //    gateway网关
    Gateway.modelName: (PortServiceInfo device) {
      return Gateway(
        device: device,
        key: UniqueKey(),
      );
    },
    //    onvif摄像头管理工具
    OvifManagerPage.modelName: (PortServiceInfo device) {
      return OvifManagerPage(
        device: device,
        key: UniqueKey(),
      );
    },
    //    VNC MacOS可测试
    VNCWebPage.modelName: (PortServiceInfo device) {
      return VNCWebPage(
        device: device,
        key: UniqueKey(),
      );
    },
    VideoPlayer.modelName: (PortServiceInfo device) {
      return VideoPlayer(
        device: device,
        key: UniqueKey(),
      );
    },
    MqttPhicommzDC1PluginPage.modelName: (PortServiceInfo device) {
      return MqttPhicommzDC1PluginPage(
        device: device,
        key: UniqueKey(),
      );
    },
    MqttPhicommzTc1A1PluginPage.modelName: (PortServiceInfo device) {
      return MqttPhicommzTc1A1PluginPage(
        device: device,
        key: UniqueKey(),
      );
    },
    MqttPhicommzA1PluginPage.modelName: (PortServiceInfo device) {
      return MqttPhicommzA1PluginPage(
        device: device,
        key: UniqueKey(),
      );
    },
    MqttPhicommzM1PluginPage.modelName: (PortServiceInfo device) {
      return MqttPhicommzM1PluginPage(
        device: device,
        key: UniqueKey(),
      );
    },
    SSHNativePage.modelName: (PortServiceInfo device) {
      return SSHNativePage(
        device: device,
        key: UniqueKey(),
      );
    },
  });
}
