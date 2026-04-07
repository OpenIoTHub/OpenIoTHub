import 'package:flutter/material.dart';

import 'package:openiothub/plugin/mdns_service/components.dart';
import 'package:openiothub/plugin/mdns_service/services/nas/casa_zima_os/casaos_login.dart';
import 'package:openiothub/plugin/mdns_service/services/nas/casa_zima_os/zima_login.dart';
import 'package:openiothub/plugin/mdns_service/services/nas/unraid/login.dart';
import 'package:openiothub/plugin/mdns_service/services/ssh/ssh_page.dart';
import 'package:openiothub/plugin/registry/plugin_registry.dart';

/// 内置「服务类」插件（Web、网关、NAS 登录、Unraid、Aria2、mDNS 声明、SSH、流媒体等）。
void registerBuiltinServicePlugins(PluginRegistry registry) {
  registry.registerBatch({
    WebPage.modelName: (ctx) {
      return WebPage(device: ctx.device, key: UniqueKey());
    },
    'com.94qing.devices.esp_dc1': (ctx) {
      return WebPage(device: ctx.device, key: UniqueKey());
    },
    Gateway.modelName: (ctx) {
      return Gateway(device: ctx.device, key: UniqueKey());
    },
    OvifManagerPage.modelName: (ctx) {
      return OvifManagerPage(device: ctx.device, key: UniqueKey());
    },
    VNCWebPage.modelName: (ctx) {
      return VNCWebPage(device: ctx.device, key: UniqueKey());
    },
    VideoPlayer.modelName: (ctx) {
      return VideoPlayer(device: ctx.device, key: UniqueKey());
    },
    SSHNativePage.modelName: (ctx) {
      return SSHNativePage(device: ctx.device, key: UniqueKey());
    },
    CasaLoginPage.modelName: (ctx) {
      return CasaLoginPage(device: ctx.device, key: UniqueKey());
    },
    ZimaLoginPage.modelName: (ctx) {
      return ZimaLoginPage(device: ctx.device, key: UniqueKey());
    },
    Aria2Page.modelName: (ctx) {
      return Aria2Page(device: ctx.device, key: UniqueKey());
    },
    MDNSResponserPage.modelName: (ctx) {
      return MDNSResponserPage(device: ctx.device, key: UniqueKey());
    },
    UnraidLoginPage.modelName: (ctx) {
      return UnraidLoginPage(device: ctx.device, key: UniqueKey());
    },
  });
}
