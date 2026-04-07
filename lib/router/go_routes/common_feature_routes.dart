import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/pages/guide/guide_page.dart';
import 'package:openiothub/pages/profile/tools/tools_type_page.dart';
import 'package:openiothub/pages/scanner/scan_qr.dart';
import 'package:openiothub/pages/service/add_mqtt_devices_page.dart';
import 'package:openiothub/pages/service/third_device/zip_devices_page.dart';
import 'package:openiothub/plugin/openiothub_plugin.dart';
import 'package:openiothub/router/app_navigator.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/router/go_router_keys.dart';
import 'package:openiothub/router/route_extra.dart';

List<RouteBase> buildCommonFeatureRoutes() {
  return [
    GoRoute(
      path: AppRoutes.scanQr,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const ScanQRPage(),
    ),
    GoRoute(
      path: AppRoutes.feedback,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => FeedbackPage(key: UniqueKey()),
    ),
    GoRoute(
      path: AppRoutes.appInfo,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => AppInfoPage(key: UniqueKey()),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => PrivacyPolicyPage(key: UniqueKey()),
    ),
    GoRoute(
      path: AppRoutes.gatewayGuide,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => GatewayGuidePage(key: UniqueKey()),
    ),
    GoRoute(
      path: AppRoutes.gatewayQr,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const GatewayQrPage(),
    ),
    GoRoute(
      path: AppRoutes.findGateway,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const FindGatewayGoListPage(),
    ),
    GoRoute(
      path: AppRoutes.tools,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => ToolsTypePage(key: UniqueKey()),
    ),
    GoRoute(
      path: AppRoutes.zipDevices,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const ZipDevicesPage(),
    ),
    GoRoute(
      path: AppRoutes.addMqttDevices,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const AddMqttDevicesPage(),
    ),
    GoRoute(
      path: AppRoutes.guide,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final activeIndex = OpenIoTHubRouteExtra.integer(
          state.extra,
          AppNavigator.argActiveIndex,
          0,
        );
        return GuidePage(
          key: UniqueKey(),
          activeIndex: activeIndex,
        );
      },
    ),
  ];
}
