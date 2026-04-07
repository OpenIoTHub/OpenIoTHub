import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/common_pages/user/account_security_page.dart';
import 'package:openiothub/router/app_navigator.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/router/go_router_keys.dart';
import 'package:openiothub/router/route_extra.dart';
import 'package:openiothub/widgets/language_picker.dart';
import 'package:openiothub/widgets/theme_color_picker.dart';
import 'package:openiothub/widgets/theme_mode_picker.dart';

List<RouteBase> buildUserSettingsRoutes() {
  return [
    GoRoute(
      path: AppRoutes.userInfo,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const UserInfoPage(),
    ),
    GoRoute(
      path: AppRoutes.accountSecurity,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const AccountSecurityPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) {
        final title = OpenIoTHubRouteExtra.string(
              state.extra,
              AppNavigator.argTitle,
            ) ??
            '设置';
        return SettingsPage(
          key: UniqueKey(),
          title: title,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.languagePicker,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const LanguagePickerPage(),
    ),
    GoRoute(
      path: AppRoutes.themeColorPicker,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const ThemeColorPickerPage(),
    ),
    GoRoute(
      path: AppRoutes.themeModePicker,
      parentNavigatorKey: openIoTHubRootNavigatorKey,
      builder: (context, state) => const ThemeModePickerPage(),
    ),
  ];
}
