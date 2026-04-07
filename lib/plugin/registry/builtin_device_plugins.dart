import 'package:flutter/material.dart';

import 'package:openiothub/plugin/mdns_service/components.dart';
import 'package:openiothub/plugin/registry/plugin_registry.dart';

/// 内置「设备类」插件（传感器、斐讯、MQTT 设备等）。
void registerBuiltinDevicePlugins(PluginRegistry registry) {
  registry.registerBatch({
    OneKeySwitchPage.modelName: (ctx) {
      return OneKeySwitchPage(device: ctx.device, key: UniqueKey());
    },
    PhicommDC1PluginPage.modelName: (ctx) {
      return PhicommDC1PluginPage(device: ctx.device, key: UniqueKey());
    },
    PhicommTC1A1PluginPage.modelName: (ctx) {
      return PhicommTC1A1PluginPage(device: ctx.device, key: UniqueKey());
    },
    'com#iotserv#devices#phicomm_tc1_a1': (ctx) {
      return PhicommTC1A1PluginPage(device: ctx.device, key: UniqueKey());
    },
    DHTPage.modelName: (ctx) {
      return DHTPage(device: ctx.device, key: UniqueKey());
    },
    LightLevelPage.modelName: (ctx) {
      return LightLevelPage(device: ctx.device, key: UniqueKey());
    },
    RGBALedPage.modelName: (ctx) {
      return RGBALedPage(device: ctx.device, key: UniqueKey());
    },
    Serial315433Page.modelName: (ctx) {
      return Serial315433Page(device: ctx.device, key: UniqueKey());
    },
    PhicommR1ControlerPage.modelName: (ctx) {
      return PhicommR1ControlerPage(device: ctx.device, key: UniqueKey());
    },
    UART2TCPPage.modelName: (ctx) {
      return UART2TCPPage(device: ctx.device, key: UniqueKey());
    },
    MqttPhicommzDC1PluginPage.modelName: (ctx) {
      return MqttPhicommzDC1PluginPage(device: ctx.device, key: UniqueKey());
    },
    MqttPhicommzTc1A1PluginPage.modelName: (ctx) {
      return MqttPhicommzTc1A1PluginPage(device: ctx.device, key: UniqueKey());
    },
    MqttPhicommzA1PluginPage.modelName: (ctx) {
      return MqttPhicommzA1PluginPage(device: ctx.device, key: UniqueKey());
    },
    MqttPhicommzM1PluginPage.modelName: (ctx) {
      return MqttPhicommzM1PluginPage(device: ctx.device, key: UniqueKey());
    },
  });
}
