import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/providers/auth_provider.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/router/go_router_keys.dart';
import 'package:openiothub/router/go_routes/auth_root_routes.dart';
import 'package:openiothub/router/go_routes/common_feature_routes.dart';
import 'package:openiothub/router/go_routes/device_service_routes.dart';
import 'package:openiothub/router/go_routes/home_main_shell_routes.dart';
import 'package:openiothub/router/go_routes/user_settings_routes.dart';
import 'package:openiothub/router/go_routes/web_routes.dart';

/// 创建绑定 [AuthProvider] 的 [GoRouter]；登录态变化时通过 [refreshListenable] 重算 [redirect]。
GoRouter createOpenIoTHubRouter(AuthProvider auth) {
  return GoRouter(
    navigatorKey: openIoTHubRootNavigatorKey,
    initialLocation: AppRoutes.root,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: auth,
    redirect: (BuildContext context, GoRouterState state) {
      final loc = state.matchedLocation;
      final loggingIn =
          loc == AppRoutes.login || loc == AppRoutes.register;
      final atRoot = loc == AppRoutes.root;

      if (auth.isLoading) {
        if (atRoot) return null;
        if (!auth.isAuthenticated && AppRoutes.requiresAuth(loc)) {
          return AppRoutes.login;
        }
        return null;
      }

      if (atRoot) {
        return auth.isAuthenticated ? AppRoutes.home : AppRoutes.login;
      }

      if (!auth.isAuthenticated) {
        if (AppRoutes.requiresAuth(loc)) {
          return AppRoutes.login;
        }
      } else if (loggingIn) {
        return AppRoutes.home;
      }
      return null;
    },
    errorBuilder: (context, state) {
      if (kDebugMode) {
        debugPrint(
          'GoRouter error: ${state.error} location=${state.matchedLocation} uri=${state.uri}',
        );
      }
      final message = state.error?.toString() ??
          '未知路径：${state.matchedLocation}';
      return Scaffold(
        appBar: AppBar(
          title: const Text('无法打开页面'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.root);
              }
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SelectableText(message, textAlign: TextAlign.center),
          ),
        ),
      );
    },
    routes: <RouteBase>[
      ...buildAuthRootRoutes(),
      ...buildHomeMainShellRoutes(),
      ...buildUserSettingsRoutes(),
      ...buildCommonFeatureRoutes(),
      ...buildWebRoutes(),
      ...buildDeviceServiceRoutes(),
    ],
  );
}
