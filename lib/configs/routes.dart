import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/bottom_navigation/gateway/gateway_list_page.dart';
import 'package:openiothub/pages/bottom_navigation/host/common_device_list_page.dart';
import 'package:openiothub/pages/bottom_navigation/service/mdns_service_list_page.dart';
import 'package:openiothub/pages/bottom_navigation/user/profile_page.dart';
import 'package:openiothub/pages/bottom_navigation/user/tools/tools_type_page.dart';
import 'package:openiothub/pages/common/scan_qr.dart';
import 'package:openiothub/pages/home/all/home_page.dart';
import 'package:openiothub/pages/splash/splash_ad_page.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';

// 路由路径常量
class AppRoutes {
  // 主页面
  static const String splash = '/';
  static const String home = '/home';
  
  // 底部导航页面
  static const String gateway = '/gateway';
  static const String host = '/host';
  static const String service = '/service';
  static const String profile = '/profile';
  
  // 用户相关
  static const String login = '/login';
  static const String register = '/register';
  static const String userInfo = '/userInfo';
  static const String settings = '/settings';
  static const String servers = '/servers';
  static const String tools = '/tools';
  static const String appInfo = '/appInfo';
  static const String feedback = '/feedback';
  
  // 网关相关
  static const String gatewayQr = '/gatewayQr';
  
  // 工具相关
  static const String scanQr = '/scanQr';
  
  // WiFi配置
  static const String airkiss = '/airkiss';
}

// 路由配置
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // 启动页
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashAdPage(),
    ),
    
    // 主页（带底部导航）- 使用shell路由
    ShellRoute(
      builder: (context, state, child) => MyHomePage(
        key: const ValueKey('home'),
        title: '',
        child: child,
      ),
      routes: [
        // 网关页面
        GoRoute(
          path: AppRoutes.gateway,
          builder: (context, state) => GatewayListPage(
            title: OpenIoTHubLocalizations.of(context).tab_gateway,
            key: UniqueKey(),
          ),
        ),
        
        // 主机页面
        GoRoute(
          path: AppRoutes.host,
          builder: (context, state) => CommonDeviceListPage(
            title: OpenIoTHubLocalizations.of(context).tab_host,
            key: UniqueKey(),
          ),
        ),
        
        // 服务页面
        GoRoute(
          path: AppRoutes.service,
          builder: (context, state) => MdnsServiceListPage(
            title: OpenIoTHubLocalizations.of(context).tab_smart,
            key: UniqueKey(),
          ),
        ),
        
        // 个人中心页面
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
    
    // 主页路由（重定向到gateway）
    GoRoute(
      path: AppRoutes.home,
      redirect: (context, state) => AppRoutes.gateway,
    ),
    
    // 登录页面
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    
    // 注册页面
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    
    // 用户信息页面
    GoRoute(
      path: AppRoutes.userInfo,
      builder: (context, state) => const UserInfoPage(),
    ),
    
    // 设置页面
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? 
            OpenIoTHubLocalizations.of(context).profile_settings;
        return SettingsPage(
          title: title,
          key: UniqueKey(),
        );
      },
    ),
    
    // 服务器页面
    GoRoute(
      path: AppRoutes.servers,
      builder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? 
            OpenIoTHubLocalizations.of(context).profile_servers;
        return ServerPages(
          title: title,
          key: UniqueKey(),
        );
      },
    ),
    
    // 工具页面
    GoRoute(
      path: AppRoutes.tools,
      builder: (context, state) => const ToolsTypePage(),
    ),
    
    // 应用信息页面
    GoRoute(
      path: AppRoutes.appInfo,
      builder: (context, state) => AppInfoPage(
        key: UniqueKey(),
      ),
    ),
    
    // 反馈页面
    GoRoute(
      path: AppRoutes.feedback,
      builder: (context, state) => FeedbackPage(
        key: UniqueKey(),
      ),
    ),
    
    // 网关二维码页面
    GoRoute(
      path: AppRoutes.gatewayQr,
      builder: (context, state) => GatewayQrPage(
        key: UniqueKey(),
      ),
    ),
    
    // 扫码页面
    GoRoute(
      path: AppRoutes.scanQr,
      builder: (context, state) => const ScanQRPage(),
    ),
    
    // WiFi配置页面
    GoRoute(
      path: AppRoutes.airkiss,
      builder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? 'Airkiss';
        return Airkiss(
          title: title,
          key: UniqueKey(),
        );
      },
    ),
  ],
);
