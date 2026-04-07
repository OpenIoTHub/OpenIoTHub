import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/gateway/gateway_list_page.dart';
import 'package:openiothub/pages/home/openiothub_home_shell.dart';
import 'package:openiothub/pages/host/common_device_list_page.dart';
import 'package:openiothub/pages/profile/profile_page.dart';
import 'package:openiothub/pages/service/mdns_service_list_page.dart';
import 'package:openiothub/router/app_routes.dart';

List<RouteBase> buildHomeMainShellRoutes() {
  return [
    GoRoute(
      path: AppRoutes.homeMain,
      redirect: (BuildContext context, GoRouterState state) {
        if (state.uri.path == AppRoutes.homeMain) {
          return AppRoutes.homeMainGateway;
        }
        return null;
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return OpenIoTHubHomeShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.homeMainGateway,
              builder: (context, state) => GatewayListPage(
                title: OpenIoTHubLocalizations.of(context).tab_gateway,
                key: UniqueKey(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.homeMainHost,
              builder: (context, state) => CommonDeviceListPage(
                title: OpenIoTHubLocalizations.of(context).tab_host,
                key: UniqueKey(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.homeMainSmart,
              builder: (context, state) => MdnsServiceListPage(
                title: OpenIoTHubLocalizations.of(context).tab_smart,
                key: UniqueKey(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.homeMainProfile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ];
}
