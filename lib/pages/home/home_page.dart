import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/service/mdns_service_list_page.dart';
import 'package:openiothub/pages/profile/profile_page.dart';
import 'package:openiothub/network/openiothub/utils.dart';
import 'package:openiothub/network/utils/check.dart';
import 'package:openiothub/common_pages/utils/go_to_url.dart';
import 'package:openiothub/core/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:openiothub/core/globals.dart';
import 'package:openiothub/init.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/ads/openiothub_ads.dart';
import 'package:openiothub/pages/host/common_device_list_page.dart';
import 'package:openiothub/pages/gateway/gateway_list_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required Key key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  SharedPreferences? prefs;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        // showInfo( "程序状态：${state.toString()}", context);
        // TODO 检测存活
        UtilApi.ping().then((String ret) {
          if (ret != "ok") {
            init();
            setState(() {});
          }
        });
        if (needShowSplash){
          _showSplashAd();
        }else{
          needShowSplash = true;
        }
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        // showToast( "程序状态：${state.toString()}");
        break;
      case AppLifecycleState.detached: // APP结束时调用
        exit(1);
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSharedPreferences();
    _gotoLocalGateway();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timer.cancel();
      _showReadPrivacyPolicy();
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      timer.cancel();
      // 防止跟上面的调用冲突
      if (context.isCnMainlandLocale) {
        _showSplashAd();
      } else {
        final appOpenAdManager = AppOpenAdManager();
        appOpenAdManager.loadAd();
        appOpenAdManager.showAdIfAvailable();
      }
    });
    // _showUserLoginStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(OpenIoTHubLocalizations.of(context).app_title),),
      key: _scaffoldKey,
      // drawer: DrawerUI(),
      body: _buildBody(_currentIndex),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      // floatingActionButton: _build_peedDial(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  //通过index判断展现的类型
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return GatewayListPage(
          title: OpenIoTHubLocalizations.of(context).tab_gateway,
          key: UniqueKey(),
        );
      case 1:
        return CommonDeviceListPage(
          title: OpenIoTHubLocalizations.of(context).tab_host,
          key: UniqueKey(),
        );
      case 2:
        return MdnsServiceListPage(
          title: OpenIoTHubLocalizations.of(context).tab_smart,
          key: UniqueKey(),
        );
      case 3:
        return const ProfilePage();
      default:
        return MdnsServiceListPage(
          title: OpenIoTHubLocalizations.of(context).tab_smart,
          key: UniqueKey(),
        );
    }
  }

  void _changePage(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  List<BottomNavigationBarItem> getBottomNavItems(BuildContext context) {
    final List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(
        icon: const Icon(TDIcons.internet),
        label: OpenIoTHubLocalizations.of(context).tab_gateway,
      ),
      BottomNavigationBarItem(
        icon: const Icon(TDIcons.desktop),
        label: OpenIoTHubLocalizations.of(context).tab_host,
      ),
      BottomNavigationBarItem(
        icon: const Icon(TDIcons.control_platform),
        label: OpenIoTHubLocalizations.of(context).tab_smart,
      ),
      BottomNavigationBarItem(
        icon: const Icon(TDIcons.user),
        label: OpenIoTHubLocalizations.of(context).tab_user,
      ),
    ];
    return bottomNavItems;
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: getBottomNavItems(context),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        _changePage(index);
      },
    );
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _gotoLocalGateway() async {
    // 如果没有登陆并且是PC平台则跳转到本地网关页面
    bool userSignedIned = await userSignedIn();
    if (!userSignedIned &&
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        timer.cancel();
        context.push(AppRoutes.gatewayQr);
      });
    }
  }

  //   展示首次进入应用提示的阅读隐私政策，后面则不会再提示
  void _showReadPrivacyPolicy() {
    // 如果没有登陆并且是PC平台则跳转到本地网关页面
    // 获取同意隐私政策状态
    bool agreed =
        prefs!.getBool(SharedPreferencesKey.agreedPrivacyPolicy) != null
            ? prefs!.getBool(SharedPreferencesKey.agreedPrivacyPolicy)!
            : false;
    // showToast("msg:$agreed");
    if (Platform.isAndroid && !agreed) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(OpenIoTHubLocalizations.of(context).privacy_policy),
              scrollable: true,
              content: SizedBox(
                height: 100, // 设置Dialog的高度
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(OpenIoTHubLocalizations.of(context).agree),
                        TextButton(
                          // 同意才可以下一步
                          child: Text(
                            '《${OpenIoTHubLocalizations.of(context).privacy_policy}》',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            goToUrl(
                              context,
                              "https://docs.iothub.cloud/privacyPolicy/index.html",
                              "《${OpenIoTHubLocalizations.of(context).privacy_policy}》",
                            );
                          },
                        ),
                        TextButton(
                          child: Text(
                            OpenIoTHubLocalizations.of(
                              context,
                            ).feedback_channels,
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () async {
                            context.push(AppRoutes.feedback);
                          },
                        ),
                      ],
                    ),
                    Text(
                      OpenIoTHubLocalizations.of(
                        context,
                      ).if_you_do_not_agree_with_the_privacy_policy_please_click_to_exit_the_application,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TDButton(
                  text:
                      OpenIoTHubLocalizations.of(context).exit_the_application,
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.danger,
                  onTap: () {
                    SystemNavigator.pop();
                  },
                ),
                TDButton(
                  text:
                      OpenIoTHubLocalizations.of(
                        context,
                      ).agree_to_the_privacy_policy,
                  size: TDButtonSize.large,
                  type: TDButtonType.fill,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.primary,
                  onTap: () async {
                    // 保存同意状态，之后不再提示,首次还会初始化微信SDK，以后直接由于有状态启动就初始化微信sdk
                    await prefs!
                        .setBool(
                          SharedPreferencesKey.agreedPrivacyPolicy,
                          true,
                        )
                        .then((_) {
                          initWechat();
                          initQQ();
                        });
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
      );
    }
  }

  _showSplashAd() async {
    // TODO 控制开屏广告时间间隔
    if (initList != null && needShowSplash) {
      // if (Platform.isIOS) {
      //   // 为了防止腾讯开屏广告启动之后算一次返回再展现一次广告，穿山甲没有这样的问题
      //   needShowSplash = false;
      // }
      if (lastDateTime!=null) {
        DateTime now = DateTime.now();
        Duration difference = now.difference(lastDateTime!);
        if (difference.inSeconds<35){
          return;
        }
      }
      lastDateTime = DateTime.now();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SplashPage(),
        ),
      );
    }
  }

}
