import 'package:openiothub/core/openiothub_constants.dart';

/// 应用内路由路径常量；跳转使用 [AppNavigator]、`context.push` / `context.go`（go_router）。
///
/// ## 新增页面
/// 1. 在此类增加路径常量；主页多 Tab 可放在 `homeMain*` 下。
/// 2. 在 `lib/router/go_routes/<域>/` 中注册 `GoRoute`（由 `lib/router/core/go_app_router.dart` 汇总）。
/// 3. 若页面**无需登录**可访问，将路径加入 [publicPaths]；否则保持默认（需登录）。
class AppRoutes {
  // --- 认证与根 ---
  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String homeMain = '/home-main';

  /// [StatefulShellRoute] 各 Tab（与 `home_main_shell_routes.dart` 分支一致）。
  static const String homeMainGateway = '/home-main/gateway';
  static const String homeMainHost = '/home-main/host';
  static const String homeMainSmart = '/home-main/smart';
  static const String homeMainProfile = '/home-main/profile';

  // --- 用户与设置 ---
  static const String userInfo = '/user-info';
  static const String accountSecurity = '/account-security';
  static const String settings = '/settings';
  static const String languagePicker = RoutePaths.languagePicker;
  static const String themeColorPicker = RoutePaths.themeColorPicker;
  static const String themeModePicker = RoutePaths.themeModePicker;

  // --- 通用功能 ---
  static const String scanQr = '/scan-qr';
  static const String feedback = '/feedback';
  static const String appInfo = '/app-info';
  static const String privacyPolicy = '/privacy-policy';
  static const String gatewayGuide = '/gateway-guide';
  static const String gatewayQr = '/gateway-qr';
  static const String findGateway = '/find-gateway';
  static const String tools = '/tools';
  static const String zipDevices = '/zip-devices';
  static const String addMqttDevices = '/add-mqtt-devices';
  static const String guide = '/guide';

  // --- Web ---
  static const String web = '/web';
  static const String fullscreenWeb = '/fullscreen-web';

  // --- 服务器与设备 ---
  static const String servers = '/servers';
  static const String serverInfo = '/server-info';
  static const String airkiss = '/airkiss';
  static const String mdnsServiceList = '/mdns-service-list';
  static const String commonDeviceList = '/common-device-list';
  static const String servicesList = '/services-list';
  static const String gatewayMdnsServiceList = '/gateway-mdns-service-list';
  static const String info = '/info';
  static const String mdnsInfo = '/mdns-info';
  static const String tcpPortList = '/tcp-port-list';
  static const String udpPortList = '/udp-port-list';
  static const String ftpPortList = '/ftp-port-list';
  static const String httpPortList = '/http-port-list';

  /// 未登录也可访问的路径（其余路径在会话就绪后均需登录，见 [requiresAuth]）。
  static const Set<String> publicPaths = {
    root,
    login,
    register,
    guide,
    languagePicker,
    themeColorPicker,
    themeModePicker,
  };

  /// 是否在「已结束加载、可判断登录态」的前提下需要登录才能停留该路径。
  static bool requiresAuth(String matchedLocation) =>
      !publicPaths.contains(matchedLocation);
}
