import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/app/app_initial_routes.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/pages/splash/splash_ad_page.dart';
import 'package:openiothub/router/core/app_routes.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

List<RouteBase> buildAuthRootRoutes() {
  return [
    GoRoute(
      path: AppRoutes.root,
      builder: (context, state) => const InitialRoute(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      redirect: (BuildContext context, GoRouterState state) {
        // 桌面（Windows / macOS / Linux）：直接进入带左侧导航的 StatefulShell，勿再用底部 Tab 的 MyHomePage。
        if (openIoTHubUseDesktopHomeLayout) {
          return AppRoutes.homeMainGateway;
        }
        return null;
      },
      builder: (context, state) => const SplashAdPage(),
    ),
  ];
}
