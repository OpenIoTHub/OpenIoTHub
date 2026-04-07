import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/router/app_routes.dart';

/// 统一导航入口：通过 [GoRouter.push] 打开应用内命名路径，参数放在 [extra]（与 [go_app_router] 中解析一致）。
///
/// ## 新增带参数页面时
/// 1. 在 [AppRoutes] 中增加路由常量，并在 `createOpenIoTHubRouter`（`go_app_router.dart`）中注册 [GoRoute]。
/// 2. 在本类中增加静态常量 argXxx（若需新参数 key），再增加 `static Future<T?> pushXxx<T>(BuildContext context, ...)`，
///    `extra` 使用 Map + arg*，与路由 builder 中读取的 key 一致。
/// 3. 业务处调用 [AppNavigator.pushXxx]，不要直接手写路径与参数。
class AppNavigator {
  AppNavigator._();

  /// 参数 key：页面标题
  static const argTitle = 'title';
  /// 参数 key：URL
  static const argUrl = 'url';
  /// 参数 key：引导页当前步骤
  static const argActiveIndex = 'activeIndex';
  /// 参数 key：设备
  static const argDevice = 'device';
  /// 参数 key：会话配置（网关）
  static const argSessionConfig = 'sessionConfig';
  /// 参数 key：端口服务信息
  static const argPortService = 'portService';
  /// 参数 key：端口配置
  static const argPortConfig = 'portConfig';
  /// 参数 key：服务器信息
  static const argServerInfo = 'serverInfo';

  static Future<T?> pushWeb<T>(BuildContext context, String url, {String? title}) {
    return GoRouter.of(context).push<T>(
      AppRoutes.web,
      extra: {argUrl: url, if (title != null) argTitle: title},
    );
  }

  static Future<T?> pushFullscreenWeb<T>(BuildContext context, String url) {
    return GoRouter.of(context).push<T>(
      AppRoutes.fullscreenWeb,
      extra: {argUrl: url},
    );
  }

  static Future<T?> pushSettings<T>(BuildContext context, {String title = '设置'}) {
    return GoRouter.of(context).push<T>(
      AppRoutes.settings,
      extra: {argTitle: title},
    );
  }

  static Future<T?> pushGuide<T>(BuildContext context, {int activeIndex = 0}) {
    return GoRouter.of(context).push<T>(
      AppRoutes.guide,
      extra: {argActiveIndex: activeIndex},
    );
  }

  static Future<T?> pushServers<T>(BuildContext context, {String title = '服务器'}) {
    return GoRouter.of(context).push<T>(
      AppRoutes.servers,
      extra: {argTitle: title},
    );
  }

  static Future<T?> pushAirkiss<T>(BuildContext context, {String title = 'WiFi配置'}) {
    return GoRouter.of(context).push<T>(
      AppRoutes.airkiss,
      extra: {argTitle: title},
    );
  }

  static Future<T?> pushMdnsServiceList<T>(BuildContext context, {String title = 'mDNS服务'}) {
    return GoRouter.of(context).push<T>(
      AppRoutes.mdnsServiceList,
      extra: {argTitle: title},
    );
  }

  static Future<T?> pushCommonDeviceList<T>(BuildContext context, {String title = '设备列表'}) {
    return GoRouter.of(context).push<T>(
      AppRoutes.commonDeviceList,
      extra: {argTitle: title},
    );
  }

  static Future<T?> pushServicesList<T>(BuildContext context, dynamic device) {
    return GoRouter.of(context).push<T>(
      AppRoutes.servicesList,
      extra: {argDevice: device},
    );
  }

  static Future<T?> pushGatewayMdnsServiceList<T>(BuildContext context, dynamic sessionConfig) {
    return GoRouter.of(context).push<T>(
      AppRoutes.gatewayMdnsServiceList,
      extra: {argSessionConfig: sessionConfig},
    );
  }

  static Future<T?> pushInfo<T>(BuildContext context, dynamic portService) {
    return GoRouter.of(context).push<T>(
      AppRoutes.info,
      extra: {argPortService: portService},
    );
  }

  static Future<T?> pushMdnsInfo<T>(BuildContext context, dynamic portConfig) {
    return GoRouter.of(context).push<T>(
      AppRoutes.mdnsInfo,
      extra: {argPortConfig: portConfig},
    );
  }

  static Future<T?> pushTcpPortList<T>(BuildContext context, dynamic device) {
    return GoRouter.of(context).push<T>(
      AppRoutes.tcpPortList,
      extra: {argDevice: device},
    );
  }

  static Future<T?> pushUdpPortList<T>(BuildContext context, dynamic device) {
    return GoRouter.of(context).push<T>(
      AppRoutes.udpPortList,
      extra: {argDevice: device},
    );
  }

  static Future<T?> pushFtpPortList<T>(BuildContext context, dynamic device) {
    return GoRouter.of(context).push<T>(
      AppRoutes.ftpPortList,
      extra: {argDevice: device},
    );
  }

  static Future<T?> pushHttpPortList<T>(BuildContext context, dynamic device) {
    return GoRouter.of(context).push<T>(
      AppRoutes.httpPortList,
      extra: {argDevice: device},
    );
  }

  static Future<T?> pushServerInfo<T>(BuildContext context, dynamic serverInfo) {
    return GoRouter.of(context).push<T>(
      AppRoutes.serverInfo,
      extra: {argServerInfo: serverInfo},
    );
  }
}
