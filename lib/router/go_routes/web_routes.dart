import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/common_pages/web/full_screen_web.dart';
import 'package:openiothub/common_pages/web/web2.dart';
import 'package:openiothub/router/app_navigator.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/router/go_router_keys.dart';
import 'package:openiothub/router/route_extra.dart';

List<RouteBase> buildWebRoutes() {
  return [
    GoRoute(
      path: AppRoutes.web,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final startUrl =
            OpenIoTHubRouteExtra.string(state.extra, AppNavigator.argUrl) ?? '';
        final title =
            OpenIoTHubRouteExtra.string(state.extra, AppNavigator.argTitle);
        return WebScreen(
          key: UniqueKey(),
          startUrl: startUrl,
          title: title,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.fullscreenWeb,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final startUrl =
            OpenIoTHubRouteExtra.string(state.extra, AppNavigator.argUrl) ?? '';
        if (startUrl.isEmpty) return OpenIoTHubRouteExtra.invalidPage();
        return FullScreenWeb(
          key: UniqueKey(),
          startUrl: startUrl,
        );
      },
    ),
  ];
}
