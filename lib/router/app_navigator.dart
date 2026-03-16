import 'package:flutter/material.dart';
import 'package:openiothub/router/app_routes.dart';

/// 统一导航入口：所有页面跳转通过此类或 [AppRoutes] + Navigator.pushNamed，避免各处手写 MaterialPageRoute。
/// 带参数的页面使用 [pushNamed] 时，参数 key 与本类及 [AppRoutes.onGenerateRoute] 保持一致。
///
/// ## 新增带参数页面时
/// 1. 在 [AppRoutes] 中增加路由常量，并在 onGenerateRoute 中解析 arguments。
/// 2. 在本类中增加静态常量 kArgXxx（若需新参数 key），再增加 `static Future<T?> pushXxx<T>(BuildContext context, ...)`，
///    arguments 使用 kArg*，与 onGenerateRoute 中读取的 key 一致。
/// 3. 业务处调用 AppNavigator.pushXxx(context, ...)，不要直接 pushNamed + Map。
class AppNavigator {
  AppNavigator._();

  /// 参数 key：页面标题
  static const kArgTitle = 'title';
  /// 参数 key：URL
  static const kArgUrl = 'url';
  /// 参数 key：引导页当前步骤
  static const kArgActiveIndex = 'activeIndex';
  /// 参数 key：设备
  static const kArgDevice = 'device';
  /// 参数 key：会话配置（网关）
  static const kArgSessionConfig = 'sessionConfig';
  /// 参数 key：端口服务信息
  static const kArgPortService = 'portService';
  /// 参数 key：端口配置
  static const kArgPortConfig = 'portConfig';
  /// 参数 key：服务器信息
  static const kArgServerInfo = 'serverInfo';

  static Future<T?> pushWeb<T>(BuildContext context, String url, {String? title}) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.web,
      arguments: {kArgUrl: url, if (title != null) kArgTitle: title},
    );
  }

  static Future<T?> pushFullscreenWeb<T>(BuildContext context, String url) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.fullscreenWeb,
      arguments: {kArgUrl: url},
    );
  }

  static Future<T?> pushSettings<T>(BuildContext context, {String title = '设置'}) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.settings,
      arguments: {kArgTitle: title},
    );
  }

  static Future<T?> pushGuide<T>(BuildContext context, {int activeIndex = 0}) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.guide,
      arguments: {kArgActiveIndex: activeIndex},
    );
  }

  static Future<T?> pushServers<T>(BuildContext context, {String title = '服务器'}) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.servers,
      arguments: {kArgTitle: title},
    );
  }

  static Future<T?> pushAirkiss<T>(BuildContext context, {String title = 'WiFi配置'}) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.airkiss,
      arguments: {kArgTitle: title},
    );
  }

  static Future<T?> pushMdnsServiceList<T>(BuildContext context, {String title = 'mDNS服务'}) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.mdnsServiceList,
      arguments: {kArgTitle: title},
    );
  }

  static Future<T?> pushCommonDeviceList<T>(BuildContext context, {String title = '设备列表'}) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.commonDeviceList,
      arguments: {kArgTitle: title},
    );
  }

  static Future<T?> pushServicesList<T>(BuildContext context, dynamic device) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.servicesList,
      arguments: {kArgDevice: device},
    );
  }

  static Future<T?> pushGatewayMdnsServiceList<T>(BuildContext context, dynamic sessionConfig) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.gatewayMdnsServiceList,
      arguments: {kArgSessionConfig: sessionConfig},
    );
  }

  static Future<T?> pushInfo<T>(BuildContext context, dynamic portService) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.info,
      arguments: {kArgPortService: portService},
    );
  }

  static Future<T?> pushMdnsInfo<T>(BuildContext context, dynamic portConfig) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.mdnsInfo,
      arguments: {kArgPortConfig: portConfig},
    );
  }

  static Future<T?> pushTcpPortList<T>(BuildContext context, dynamic device) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.tcpPortList,
      arguments: {kArgDevice: device},
    );
  }

  static Future<T?> pushUdpPortList<T>(BuildContext context, dynamic device) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.udpPortList,
      arguments: {kArgDevice: device},
    );
  }

  static Future<T?> pushFtpPortList<T>(BuildContext context, dynamic device) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.ftpPortList,
      arguments: {kArgDevice: device},
    );
  }

  static Future<T?> pushHttpPortList<T>(BuildContext context, dynamic device) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.httpPortList,
      arguments: {kArgDevice: device},
    );
  }

  static Future<T?> pushServerInfo<T>(BuildContext context, dynamic serverInfo) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.serverInfo,
      arguments: {kArgServerInfo: serverInfo},
    );
  }
}
