import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/common_pages/server_info.dart';
import 'package:openiothub/pages/gateway/mdns_service_list_page.dart';
import 'package:openiothub/pages/host/common_device_list_page.dart';
import 'package:openiothub/pages/host/services/services.dart';
import 'package:openiothub/pages/host/services/old/ftp_port_list_page.dart';
import 'package:openiothub/pages/host/services/old/http_port_list_page.dart';
import 'package:openiothub/pages/host/services/old/tcp_port_list_page.dart';
import 'package:openiothub/pages/host/services/old/udp_port_list_page.dart';
import 'package:openiothub/pages/service/mdns_service_list_page.dart';
import 'package:openiothub/plugin/models/port_service_info.dart';
import 'package:openiothub/plugin/mdns_service/comm_widgets/mdns_info.dart';
import 'package:openiothub/plugin/openiothub_plugin.dart';
import 'package:openiothub/router/app_navigator.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/router/go_router_keys.dart';
import 'package:openiothub/router/route_extra.dart';
import 'package:openiothub_grpc_api/proto/manager/serverManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

List<RouteBase> buildDeviceServiceRoutes() {
  return [
    GoRoute(
      path: AppRoutes.servers,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final title = OpenIoTHubRouteExtra.string(
              state.extra,
              AppNavigator.argTitle,
            ) ??
            '服务器';
        return ServerPages(
          key: UniqueKey(),
          title: title,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.serverInfo,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final data = OpenIoTHubRouteExtra.typed<ServerInfo>(
          state.extra,
          AppNavigator.argServerInfo,
        );
        if (data == null) return OpenIoTHubRouteExtra.invalidPage();
        return ServerInfoPage(
          key: UniqueKey(),
          serverInfo: data,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.airkiss,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final title = OpenIoTHubRouteExtra.string(
              state.extra,
              AppNavigator.argTitle,
            ) ??
            'WiFi配置';
        return Airkiss(
          key: UniqueKey(),
          title: title,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.mdnsServiceList,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final title = OpenIoTHubRouteExtra.string(
              state.extra,
              AppNavigator.argTitle,
            ) ??
            'mDNS服务';
        return MdnsServiceListPage(
          key: UniqueKey(),
          title: title,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.commonDeviceList,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final title = OpenIoTHubRouteExtra.string(
              state.extra,
              AppNavigator.argTitle,
            ) ??
            '设备列表';
        return CommonDeviceListPage(
          key: UniqueKey(),
          title: title,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.servicesList,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final device = OpenIoTHubRouteExtra.device(state.extra);
        if (device == null) return OpenIoTHubRouteExtra.invalidPage();
        return ServicesListPage(
          key: UniqueKey(),
          device: device,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.gatewayMdnsServiceList,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final sessionConfig = OpenIoTHubRouteExtra.typed<SessionConfig>(
          state.extra,
          AppNavigator.argSessionConfig,
        );
        if (sessionConfig == null) return OpenIoTHubRouteExtra.invalidPage();
        return MDNSServiceListPage(
          key: UniqueKey(),
          sessionConfig: sessionConfig,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.info,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final portService = OpenIoTHubRouteExtra.typed<PortServiceInfo>(
          state.extra,
          AppNavigator.argPortService,
        );
        if (portService == null) return OpenIoTHubRouteExtra.invalidPage();
        return InfoPage(
          key: UniqueKey(),
          portService: portService,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.mdnsInfo,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final portConfig = OpenIoTHubRouteExtra.typed<PortConfig>(
          state.extra,
          AppNavigator.argPortConfig,
        );
        if (portConfig == null) return OpenIoTHubRouteExtra.invalidPage();
        return MDNSInfoPage(
          key: UniqueKey(),
          portConfig: portConfig,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.tcpPortList,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final device = OpenIoTHubRouteExtra.device(state.extra);
        if (device == null) return OpenIoTHubRouteExtra.invalidPage();
        return TcpPortListPage(
          key: UniqueKey(),
          device: device,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.udpPortList,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final device = OpenIoTHubRouteExtra.device(state.extra);
        if (device == null) return OpenIoTHubRouteExtra.invalidPage();
        return UdpPortListPage(
          key: UniqueKey(),
          device: device,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.ftpPortList,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final device = OpenIoTHubRouteExtra.device(state.extra);
        if (device == null) return OpenIoTHubRouteExtra.invalidPage();
        return FtpPortListPage(
          key: UniqueKey(),
          device: device,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.httpPortList,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final device = OpenIoTHubRouteExtra.device(state.extra);
        if (device == null) return OpenIoTHubRouteExtra.invalidPage();
        return HttpPortListPage(
          key: UniqueKey(),
          device: device,
        );
      },
    ),
  ];
}
