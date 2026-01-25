import 'dart:io';

// import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/init.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/model/locale_provider.dart';
import 'package:openiothub/model/auth_provider.dart';
import 'package:openiothub/pages/home/all/home_page.dart';
import 'package:openiothub/pages/splash/splash_ad_page.dart';
import 'package:openiothub/pages/common/scan_qr.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_common_pages/user/LoginPage.dart';
import 'package:openiothub_common_pages/user/RegisterPage.dart';
import 'package:openiothub_common_pages/user/userInfoPage.dart';
import 'package:openiothub_common_pages/user/accountSecurityPage.dart';
import 'package:openiothub_common_pages/commPages/feedback.dart';
import 'package:openiothub_common_pages/commPages/appInfo.dart';
import 'package:openiothub_common_pages/commPages/settings.dart';
import 'package:openiothub_common_pages/commPages/privacyPolicy.dart';
import 'package:openiothub_common_pages/commPages/gatewayGuide.dart';
import 'package:openiothub_common_pages/commPages/serverInfo.dart';
import 'package:openiothub_common_pages/commPages/servers.dart';
import 'package:openiothub_common_pages/commPages/findGatewayGoList.dart';
import 'package:openiothub_common_pages/gateway/GatewayQrPage.dart';
import 'package:openiothub_common_pages/web/web2.dart';
import 'package:openiothub_common_pages/web/fullScreenWeb.dart';
import 'package:openiothub_common_pages/wifiConfig/airkiss.dart';
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
import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/info.dart';
import 'package:openiothub_plugin/plugins/mdnsService/commWidgets/mDNSInfo.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    windowManager.addListener(MyWindowListener());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomTheme()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadCurrentToken()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          // 获取系统语言
          final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
          final effectiveLocale = localeProvider.getEffectiveLocale(systemLocale);
          
          return Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return OKToast(
                child: MaterialApp(
                  title: "云亿连",
                  debugShowCheckedModeBanner: false,
                  locale: effectiveLocale,
                  localizationsDelegates: const [
                    OpenIoTHubLocalizations.delegate,
                    OpenIoTHubCommonLocalizations.delegate,
                    OpenIoTHubPluginLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: OpenIoTHubLocalizations.supportedLocales,
                  theme: CustomThemes.light,
                  darkTheme: CustomThemes.dark,
                  themeMode: ThemeMode.system,
                  initialRoute: '/',
                  navigatorObservers: [
                    AuthNavigatorObserver(authProvider: authProvider),
                  ],
                  routes: {
                '/': (context) => const _InitialRoute(),
                '/login': (context) => LoginPage(),
                '/register': (context) => RegisterPage(),
                '/home': (context) => Platform.isAndroid || Platform.isIOS
                    ? const SplashAdPage()
                    : MyHomePage(
                        key: UniqueKey(),
                        title: '',
                      ),
                '/home-main': (context) => _HomeMainRoute(),
                '/scan-qr': (context) => const ScanQRPage(),
                '/user-info': (context) => UserInfoPage(),
                '/account-security': (context) => AccountSecurityPage(),
                '/feedback': (context) => FeedbackPage(key: UniqueKey()),
                '/app-info': (context) => AppInfoPage(key: UniqueKey()),
                '/privacy-policy': (context) => PrivacyPolicyPage(key: UniqueKey()),
                '/gateway-guide': (context) => GatewayGuidePage(key: UniqueKey()),
                '/gateway-qr': (context) => const GatewayQrPage(),
                '/find-gateway': (context) => const FindGatewayGoListPage(),
                '/tools': (context) => ToolsTypePage(key: UniqueKey()),
                '/zip-devices': (context) => const ZipDevicesPage(),
                '/add-mqtt-devices': (context) => const AddMqttDevicesPage(),
              },
              onGenerateRoute: (settings) {
                // 处理需要参数的页面
                switch (settings.name) {
                  case '/web':
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
                  case '/settings':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final title = args?['title'] as String? ?? '设置';
                    return MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        key: UniqueKey(),
                        title: title,
                      ),
                    );
                  case '/server-info':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final serverInfo = args?['serverInfo'];
                    if (serverInfo != null) {
                      return MaterialPageRoute(
                        builder: (context) => ServerInfoPage(
                          key: UniqueKey(),
                          serverInfo: serverInfo,
                        ),
                      );
                    }
                    return null;
                  case '/guide':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final activeIndex = args?['activeIndex'] as int? ?? 0;
                    return MaterialPageRoute(
                      builder: (context) => GuidePage(
                        key: UniqueKey(),
                        activeIndex: activeIndex,
                      ),
                    );
                  case '/fullscreen-web':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final startUrl = args?['url'] as String? ?? '';
                    if (startUrl.isEmpty) return null;
                    return MaterialPageRoute(
                      builder: (context) => FullScreenWeb(
                        key: UniqueKey(),
                        startUrl: startUrl,
                      ),
                    );
                  case '/servers':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final title = args?['title'] as String? ?? '服务器';
                    return MaterialPageRoute(
                      builder: (context) => ServerPages(
                        key: UniqueKey(),
                        title: title,
                      ),
                    );
                  case '/airkiss':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final title = args?['title'] as String? ?? 'WiFi配置';
                    return MaterialPageRoute(
                      builder: (context) => Airkiss(
                        key: UniqueKey(),
                        title: title,
                      ),
                    );
                  case '/mdns-service-list':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final title = args?['title'] as String? ?? 'mDNS服务';
                    return MaterialPageRoute(
                      builder: (context) => MdnsServiceListPage(
                        key: UniqueKey(),
                        title: title,
                      ),
                    );
                  case '/common-device-list':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final title = args?['title'] as String? ?? '设备列表';
                    return MaterialPageRoute(
                      builder: (context) => CommonDeviceListPage(
                        key: UniqueKey(),
                        title: title,
                      ),
                    );
                  case '/services-list':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final device = args?['device'];
                    if (device == null) return null;
                    return MaterialPageRoute(
                      builder: (context) => ServicesListPage(
                        key: UniqueKey(),
                        device: device,
                      ),
                    );
                  case '/gateway-mdns-service-list':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final sessionConfig = args?['sessionConfig'];
                    if (sessionConfig == null) return null;
                    return MaterialPageRoute(
                      builder: (context) => MDNSServiceListPage(
                        key: UniqueKey(),
                        sessionConfig: sessionConfig,
                      ),
                    );
                  case '/info':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final portService = args?['portService'];
                    if (portService == null) return null;
                    return MaterialPageRoute(
                      builder: (context) => InfoPage(
                        key: UniqueKey(),
                        portService: portService,
                      ),
                    );
                  case '/mdns-info':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final portConfig = args?['portConfig'];
                    if (portConfig == null) return null;
                    return MaterialPageRoute(
                      builder: (context) => MDNSInfoPage(
                        key: UniqueKey(),
                        portConfig: portConfig,
                      ),
                    );
                  case '/tcp-port-list':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final device = args?['device'];
                    if (device == null) return null;
                    return MaterialPageRoute(
                      builder: (context) => TcpPortListPage(
                        key: UniqueKey(),
                        device: device,
                      ),
                    );
                  case '/udp-port-list':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final device = args?['device'];
                    if (device == null) return null;
                    return MaterialPageRoute(
                      builder: (context) => UdpPortListPage(
                        key: UniqueKey(),
                        device: device,
                      ),
                    );
                  case '/ftp-port-list':
                    final args = settings.arguments as Map<String, dynamic>?;
                    final device = args?['device'];
                    if (device == null) return null;
                    return MaterialPageRoute(
                      builder: (context) => FtpPortListPage(
                        key: UniqueKey(),
                        device: device,
                      ),
                    );
                  case '/http-port-list':
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
              },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 路由拦截器：监听认证状态并拦截需要登录的路由
class AuthNavigatorObserver extends NavigatorObserver {
  final AuthProvider authProvider;
  bool _isHandlingAuthChange = false;

  AuthNavigatorObserver({required this.authProvider}) {
    // 监听认证状态变化
    authProvider.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    if (_isHandlingAuthChange) return;
    
    // 如果用户未登录，检查当前路由并跳转到登录页面
    if (!authProvider.isAuthenticated && !authProvider.isLoading) {
      _isHandlingAuthChange = true;
      
      // 延迟执行，避免在路由变化过程中触发
      Future.microtask(() {
        _isHandlingAuthChange = false;
        final navigator = this.navigator;
        if (navigator != null) {
          final currentRoute = ModalRoute.of(navigator.context);
          if (currentRoute != null) {
            final routeName = currentRoute.settings.name;
            // 如果当前不在登录页面或注册页面，则跳转到登录页面
            if (routeName != '/login' && routeName != '/register' && routeName != '/') {
              navigator.pushNamedAndRemoveUntil(
                '/login',
                (route) => route.settings.name == '/login' || route.settings.name == '/',
              );
            }
          }
        }
      });
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkAuthAndRedirect(route);
    // 如果跳转到登录页面，重新加载 token 以确保状态同步
    if (route.settings.name == '/login') {
      authProvider.loadCurrentToken();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _checkAuthAndRedirect(newRoute);
      // 如果跳转到登录页面，重新加载 token 以确保状态同步
      if (newRoute.settings.name == '/login') {
        authProvider.loadCurrentToken();
      }
    }
  }

  void _checkAuthAndRedirect(Route<dynamic> route) {
    // 需要认证的路由列表
    const protectedRoutes = [
      '/home',
      '/home-main',
      '/user-info',
      '/account-security',
      '/feedback',
      '/app-info',
      '/privacy-policy',
      '/gateway-guide',
      '/gateway-qr',
      '/find-gateway',
      '/tools',
      '/zip-devices',
      '/add-mqtt-devices',
    ];

    final routeName = route.settings.name;
    
    // 如果路由需要认证但用户未登录，跳转到登录页面
    if (routeName != null && 
        protectedRoutes.contains(routeName) && 
        !authProvider.isAuthenticated && 
        !authProvider.isLoading) {
      // 重新加载 token 以确保状态同步（可能在退出登录时 token 已被清除）
      authProvider.loadCurrentToken().then((_) {
        Future.microtask(() {
          final navigator = this.navigator;
          if (navigator != null && !authProvider.isAuthenticated) {
            navigator.pushNamedAndRemoveUntil(
              '/login',
              (route) => route.settings.name == '/login' || route.settings.name == '/',
            );
          }
        });
      });
    }
  }

  void dispose() {
    authProvider.removeListener(_onAuthStateChanged);
  }
}

class _InitialRoute extends StatefulWidget {
  const _InitialRoute();

  @override
  State<_InitialRoute> createState() => _InitialRouteState();
}

class _InitialRouteState extends State<_InitialRoute> {
  @override
  void initState() {
    super.initState();
    // 确保AuthProvider加载token
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isLoading) {
        authProvider.loadCurrentToken();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

// class PcApp extends StatelessWidget {
//   const PcApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return OKToast(
//         child: fluent_ui.FluentApp(
//       title: OpenIoTHubCommonLocalizations.of(context).app_title,
//       theme: fluent_ui.FluentThemeData(accentColor: fluent_ui.Colors.orange),
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: const [
//         OpenIoTHubLocalizations.delegate,
//         OpenIoTHubCommonLocalizations.delegate,
//         OpenIoTHubPluginLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         fluent_ui.FluentLocalizations.delegate,
//       ],
//       supportedLocales: OpenIoTHubLocalizations.supportedLocales,
//       localeListResolutionCallback: (locales, supportedLocales) {
//         print("locales:$locales");
//         return;
//       },
//       home: const PcHomePage(
//         title: '',
//       ),
//     ));
//   }
// }

class _HomeMainRoute extends StatefulWidget {
  const _HomeMainRoute();

  @override
  State<_HomeMainRoute> createState() => _HomeMainRouteState();
}

class _HomeMainRouteState extends State<_HomeMainRoute> {
  @override
  void initState() {
    super.initState();
    // 登录后跳转到这里时，重新加载token以更新AuthProvider状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.loadCurrentToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyHomePage(
      key: UniqueKey(),
      title: '',
    );
  }
}

class MyWindowListener extends WindowListener {
  @override
  void onWindowClose() {
    // 处理窗口关闭事件
    print("onWindowClose");
    exit(0);
  }

  @override
  void onWindowMaximize() {
    // 处理窗口最大化事件
    print("onWindowMaximize");
  }
}
