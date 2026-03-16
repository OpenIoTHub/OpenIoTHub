import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub/pages/home/all/home_page.dart';
import 'package:openiothub/pages/splash/splash_ad_page.dart';
import 'package:openiothub/pages/common/scan_qr.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_common_pages/user/accountSecurityPage.dart';
import 'package:openiothub_common_pages/commPages/serverInfo.dart';
import 'package:openiothub_common_pages/web/web2.dart';
import 'package:openiothub_common_pages/web/fullScreenWeb.dart';
import 'package:openiothub/pages/guide/guide_page.dart';
import 'package:openiothub/pages/bottom_navigation/user/tools/tools_type_page.dart';
import 'package:openiothub/pages/bottom_navigation/service/mdns_service_list_page.dart';
import 'package:openiothub/pages/bottom_navigation/service/add_mqtt_devices_page.dart';
import 'package:openiothub/pages/bottom_navigation/service/third_device/zip_devices_page.dart';
import 'package:openiothub/pages/bottom_navigation/host/common_device_list_page.dart';
import 'package:openiothub/pages/bottom_navigation/host/services/services.dart';
import 'package:openiothub/pages/bottom_navigation/gateway/mdns_service_list_page.dart';
import 'package:openiothub/pages/bottom_navigation/host/services/old/tcp_port_list_page.dart';
import 'package:openiothub/pages/bottom_navigation/host/services/old/udp_port_list_page.dart';
import 'package:openiothub/pages/bottom_navigation/host/services/old/ftp_port_list_page.dart';
import 'package:openiothub/pages/bottom_navigation/host/services/old/http_port_list_page.dart';
import 'package:openiothub/widgets/language_picker.dart';
import 'package:openiothub/widgets/theme_color_picker.dart';
import 'package:openiothub/widgets/theme_mode_picker.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/mDNSInfo.dart';
import 'package:openiothub_constants/openiothub_constants.dart';

/// 应用内所有页面路由的唯一定义与生成。
/// 跳转请使用 [AppRoutes] 常量 + [AppNavigator] 方法，避免硬编码路径和直接 MaterialPageRoute。
///
/// ## 新增页面路由时的步骤
/// 1. 在本类中增加路由常量（如 `static const String xxx = '/xxx';`），按分区放在对应注释下。
/// 2. 若无参数：在 [buildStaticRoutes] 中增加 `路由名: (context) => YourPage(),`。
/// 3. 若有参数：在 [onGenerateRoute] 的 switch 中增加 case，从 `settings.arguments` 取参并构建 [MaterialPageRoute]；
///    参数 key 与 [AppNavigator] 中的 kArg* 常量一致。
/// 4. 在 [AppNavigator] 中增加对应的 `pushXxx(context, ...)` 方法（可选但推荐），内部用 pushNamed + arguments。
/// 5. 业务处跳转使用 `Navigator.pushNamed(context, AppRoutes.xxx)` 或 `AppNavigator.pushXxx(context, ...)`，禁止手写 MaterialPageRoute。
class AppRoutes {
  // --- 认证与根 ---
  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String homeMain = '/home-main';

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

  static const List<String> protectedRoutes = [
    home,
    homeMain,
    userInfo,
    accountSecurity,
    feedback,
    appInfo,
    privacyPolicy,
    gatewayGuide,
    gatewayQr,
    findGateway,
    tools,
    zipDevices,
    addMqttDevices,
  ];

  static Map<String, WidgetBuilder> buildStaticRoutes({
    required Widget initialRouteWidget,
    required Widget homeMainWidget,
  }) {
    return {
      root: (context) => initialRouteWidget,
      login: (context) => LoginPage(),
      register: (context) => RegisterPage(),
      home: (context) => Platform.isAndroid || Platform.isIOS
          ? const SplashAdPage()
          : MyHomePage(key: UniqueKey(), title: ''),
      homeMain: (context) => homeMainWidget,
      scanQr: (context) => const ScanQRPage(),
      userInfo: (context) => UserInfoPage(),
      accountSecurity: (context) => AccountSecurityPage(),
      feedback: (context) => FeedbackPage(key: UniqueKey()),
      appInfo: (context) => AppInfoPage(key: UniqueKey()),
      privacyPolicy: (context) => PrivacyPolicyPage(key: UniqueKey()),
      gatewayGuide: (context) => GatewayGuidePage(key: UniqueKey()),
      gatewayQr: (context) => const GatewayQrPage(),
      findGateway: (context) => const FindGatewayGoListPage(),
      tools: (context) => ToolsTypePage(key: UniqueKey()),
      zipDevices: (context) => const ZipDevicesPage(),
      addMqttDevices: (context) => const AddMqttDevicesPage(),
      languagePicker: (context) => const LanguagePickerPage(),
      themeColorPicker: (context) => const ThemeColorPickerPage(),
      themeModePicker: (context) => const ThemeModePickerPage(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case web:
        final args = settings.arguments as Map<String, dynamic>?;
        final startUrl = args?['url'] as String? ?? '';
        final title = args?['title'] as String?;
        return MaterialPageRoute(
          builder: (context) => WebScreen(
            key: UniqueKey(),
            startUrl: startUrl,
            title: title,
          ),
        );
      case AppRoutes.settings:
        final args = settings.arguments as Map<String, dynamic>?;
        final title = args?['title'] as String? ?? '设置';
        return MaterialPageRoute(
          builder: (context) => SettingsPage(
            key: UniqueKey(),
            title: title,
          ),
        );
      case serverInfo:
        final args = settings.arguments as Map<String, dynamic>?;
        final serverInfoData = args?['serverInfo'];
        if (serverInfoData == null) return null;
        return MaterialPageRoute(
          builder: (context) => ServerInfoPage(
            key: UniqueKey(),
            serverInfo: serverInfoData,
          ),
        );
      case guide:
        final args = settings.arguments as Map<String, dynamic>?;
        final activeIndex = args?['activeIndex'] as int? ?? 0;
        return MaterialPageRoute(
          builder: (context) => GuidePage(
            key: UniqueKey(),
            activeIndex: activeIndex,
          ),
        );
      case fullscreenWeb:
        final args = settings.arguments as Map<String, dynamic>?;
        final startUrl = args?['url'] as String? ?? '';
        if (startUrl.isEmpty) return null;
        return MaterialPageRoute(
          builder: (context) => FullScreenWeb(
            key: UniqueKey(),
            startUrl: startUrl,
          ),
        );
      case servers:
        final args = settings.arguments as Map<String, dynamic>?;
        final title = args?['title'] as String? ?? '服务器';
        return MaterialPageRoute(
          builder: (context) => ServerPages(
            key: UniqueKey(),
            title: title,
          ),
        );
      case airkiss:
        final args = settings.arguments as Map<String, dynamic>?;
        final title = args?['title'] as String? ?? 'WiFi配置';
        return MaterialPageRoute(
          builder: (context) => Airkiss(
            key: UniqueKey(),
            title: title,
          ),
        );
      case mdnsServiceList:
        final args = settings.arguments as Map<String, dynamic>?;
        final title = args?['title'] as String? ?? 'mDNS服务';
        return MaterialPageRoute(
          builder: (context) => MdnsServiceListPage(
            key: UniqueKey(),
            title: title,
          ),
        );
      case commonDeviceList:
        final args = settings.arguments as Map<String, dynamic>?;
        final title = args?['title'] as String? ?? '设备列表';
        return MaterialPageRoute(
          builder: (context) => CommonDeviceListPage(
            key: UniqueKey(),
            title: title,
          ),
        );
      case servicesList:
        final args = settings.arguments as Map<String, dynamic>?;
        final device = args?['device'];
        if (device == null) return null;
        return MaterialPageRoute(
          builder: (context) => ServicesListPage(
            key: UniqueKey(),
            device: device,
          ),
        );
      case gatewayMdnsServiceList:
        final args = settings.arguments as Map<String, dynamic>?;
        final sessionConfig = args?['sessionConfig'];
        if (sessionConfig == null) return null;
        return MaterialPageRoute(
          builder: (context) => MDNSServiceListPage(
            key: UniqueKey(),
            sessionConfig: sessionConfig,
          ),
        );
      case info:
        final args = settings.arguments as Map<String, dynamic>?;
        final portService = args?['portService'];
        if (portService == null) return null;
        return MaterialPageRoute(
          builder: (context) => InfoPage(
            key: UniqueKey(),
            portService: portService,
          ),
        );
      case mdnsInfo:
        final args = settings.arguments as Map<String, dynamic>?;
        final portConfig = args?['portConfig'];
        if (portConfig == null) return null;
        return MaterialPageRoute(
          builder: (context) => MDNSInfoPage(
            key: UniqueKey(),
            portConfig: portConfig,
          ),
        );
      case tcpPortList:
        final args = settings.arguments as Map<String, dynamic>?;
        final device = args?['device'];
        if (device == null) return null;
        return MaterialPageRoute(
          builder: (context) => TcpPortListPage(
            key: UniqueKey(),
            device: device,
          ),
        );
      case udpPortList:
        final args = settings.arguments as Map<String, dynamic>?;
        final device = args?['device'];
        if (device == null) return null;
        return MaterialPageRoute(
          builder: (context) => UdpPortListPage(
            key: UniqueKey(),
            device: device,
          ),
        );
      case ftpPortList:
        final args = settings.arguments as Map<String, dynamic>?;
        final device = args?['device'];
        if (device == null) return null;
        return MaterialPageRoute(
          builder: (context) => FtpPortListPage(
            key: UniqueKey(),
            device: device,
          ),
        );
      case httpPortList:
        final args = settings.arguments as Map<String, dynamic>?;
        final device = args?['device'];
        if (device == null) return null;
        return MaterialPageRoute(
          builder: (context) => HttpPortListPage(
            key: UniqueKey(),
            device: device,
          ),
        );
      default:
        return null;
    }
  }
}
