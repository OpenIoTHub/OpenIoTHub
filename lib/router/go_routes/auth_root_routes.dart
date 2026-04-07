import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/app_initial_routes.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/pages/home/home_page.dart';
import 'package:openiothub/pages/splash/splash_ad_page.dart';
import 'package:openiothub/router/app_routes.dart';

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
      builder: (context, state) => Platform.isAndroid || Platform.isIOS
          ? const SplashAdPage()
          : MyHomePage(key: UniqueKey(), title: ''),
    ),
  ];
}
