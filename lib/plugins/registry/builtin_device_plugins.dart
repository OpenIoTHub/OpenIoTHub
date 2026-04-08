import 'package:flutter/material.dart';

import 'package:openiothub/plugins/mdns_service/shared/components.dart';
import 'package:openiothub/plugins/registry/openiothub_plugin_definition.dart';
import 'package:openiothub/plugins/registry/plugin_registry.dart';

/// 内置「设备类」插件（传感器、斐讯、MQTT 设备等）。
void registerBuiltinDevicePlugins(PluginRegistry registry) {
  registry.registerPluginBatch([
    (
      definition: OpenIoTHubPluginDefinition.device(OneKeySwitchPage.modelName),
      builder: (ctx) =>
          OneKeySwitchPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.device(PhicommDC1PluginPage.modelName),
      builder: (ctx) =>
          PhicommDC1PluginPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.device(
        PhicommTC1A1PluginPage.modelName,
        aliases: const ['com#iotserv#devices#phicomm_tc1_a1'],
      ),
      builder: (ctx) =>
          PhicommTC1A1PluginPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.device(DHTPage.modelName),
      builder: (ctx) => DHTPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.device(LightLevelPage.modelName),
      builder: (ctx) =>
          LightLevelPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.device(RGBALedPage.modelName),
      builder: (ctx) =>
          RGBALedPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.device(Serial315433Page.modelName),
      builder: (ctx) =>
          Serial315433Page(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition:
          OpenIoTHubPluginDefinition.device(PhicommR1ControlerPage.modelName),
      builder: (ctx) =>
          PhicommR1ControlerPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.device(UART2TCPPage.modelName),
      builder: (ctx) =>
          UART2TCPPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition:
          OpenIoTHubPluginDefinition.device(MqttPhicommzDC1PluginPage.modelName),
      builder: (ctx) =>
          MqttPhicommzDC1PluginPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition:
          OpenIoTHubPluginDefinition.device(MqttPhicommzTc1A1PluginPage.modelName),
      builder: (ctx) =>
          MqttPhicommzTc1A1PluginPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition:
          OpenIoTHubPluginDefinition.device(MqttPhicommzA1PluginPage.modelName),
      builder: (ctx) =>
          MqttPhicommzA1PluginPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition:
          OpenIoTHubPluginDefinition.device(MqttPhicommzM1PluginPage.modelName),
      builder: (ctx) =>
          MqttPhicommzM1PluginPage(device: ctx.device, key: UniqueKey()),
    ),
  ]);
}
