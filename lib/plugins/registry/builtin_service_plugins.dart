import 'package:flutter/material.dart';

import 'package:openiothub/plugins/mdns_service/shared/components.dart';
import 'package:openiothub/plugins/mdns_service/services/nas/casa_zima_os/casaos_login.dart';
import 'package:openiothub/plugins/mdns_service/services/nas/casa_zima_os/zima_login.dart';
import 'package:openiothub/plugins/mdns_service/services/nas/unraid/login.dart';
import 'package:openiothub/plugins/mdns_service/services/ssh/ssh_page.dart';
import 'package:openiothub/plugins/registry/openiothub_plugin_definition.dart';
import 'package:openiothub/plugins/registry/plugin_registry.dart';

/// 内置「服务类」插件（Web、网关、NAS 登录、Unraid、Aria2、mDNS 声明、SSH、流媒体等）。
void registerBuiltinServicePlugins(PluginRegistry registry) {
  registry.registerPluginBatch([
    (
      definition: OpenIoTHubPluginDefinition.service(
        WebPage.modelName,
        aliases: const ['com.94qing.devices.esp_dc1'],
      ),
      builder: (ctx) => WebPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.service(Gateway.modelName),
      builder: (ctx) => Gateway(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.service(OvifManagerPage.modelName),
      builder: (ctx) =>
          OvifManagerPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.service(VNCWebPage.modelName),
      builder: (ctx) =>
          VNCWebPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.service(VideoPlayer.modelName),
      builder: (ctx) =>
          VideoPlayer(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.service(SSHNativePage.modelName),
      builder: (ctx) =>
          SSHNativePage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.service(CasaLoginPage.modelName),
      builder: (ctx) =>
          CasaLoginPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.service(ZimaLoginPage.modelName),
      builder: (ctx) =>
          ZimaLoginPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.service(Aria2Page.modelName),
      builder: (ctx) =>
          Aria2Page(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition:
          OpenIoTHubPluginDefinition.service(MDNSResponserPage.modelName),
      builder: (ctx) =>
          MDNSResponserPage(device: ctx.device, key: UniqueKey()),
    ),
    (
      definition: OpenIoTHubPluginDefinition.service(UnraidLoginPage.modelName),
      builder: (ctx) =>
          UnraidLoginPage(device: ctx.device, key: UniqueKey()),
    ),
  ]);
}
