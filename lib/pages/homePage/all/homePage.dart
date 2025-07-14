import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/mdnsService/mdnsServiceListPage.dart';
import 'package:openiothub/pages/user/profilePage.dart';
import 'package:openiothub/widgets/toast.dart';
import 'package:openiothub_api/api/OpenIoTHub/Utils.dart';
import 'package:openiothub_api/utils/check.dart';
import 'package:openiothub_common_pages/commPages/feedback.dart';
import 'package:openiothub_common_pages/gateway/GatewayQrPage.dart';
import 'package:openiothub_common_pages/utils/goToUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../configs/consts.dart';
import '../../../configs/var.dart';
import '../../../init.dart';
import '../../../widgets/ads/splash_page_gtads.dart';
import '../../commonDevice/commonDeviceListPage.dart';
import '../../gateway/gatewayListPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required Key key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final Color _activeColor = Colors.orange;
  int _currentIndex = 0;
  SharedPreferences? prefs;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        // show_info( "程序状态：${state.toString()}", context);
        // TODO 检测存活
        try {
          UtilApi.Ping();
        }catch (e){
          show_failed(e.toString(), context);
          initBackgroundService();
          setState(() {});
        }
        if (initList != null && needShowSplash) {
          if (Platform.isIOS) {
            // 为了防止腾讯开屏广告启动之后算一次返回再展现一次广告，穿山甲没有这样的问题
            needShowSplash = false;
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SplashPage();
          }));
        }
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        // showToast( "程序状态：${state.toString()}");
        break;
      case AppLifecycleState.detached: // APP结束时调用
        // showToast( "程序状态：${state.toString()}");
        exit(1);
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSharedPreferences();
    _goto_local_gateway();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timer.cancel();
      _show_read_privacy_policy();
    });
    if (initList != null && needShowSplash) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SplashPage();
      }));
    }
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
        bottomNavigationBar: _buildBottomNavigationBar());
  }

//通过index判断展现的类型
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return MdnsServiceListPage(
          title: OpenIoTHubLocalizations.of(context).tab_smart,
          key: UniqueKey(),
        );
        break;
      case 1:
        return GatewayListPage(
          title: OpenIoTHubLocalizations.of(context).tab_gateway,
          key: UniqueKey(),
        );
        break;
      case 2:
        return CommonDeviceListPage(
          title: OpenIoTHubLocalizations.of(context).tab_host,
          key: UniqueKey(),
        );
        break;
      case 3:
        // return UserInfoPage();
        return const ProfilePage();
        break;
    }
    return MdnsServiceListPage(
      title: OpenIoTHubLocalizations.of(context).tab_smart,
      key: UniqueKey(),
    );
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
          icon: const Icon(TDIcons.home),
          label: OpenIoTHubLocalizations.of(context).tab_smart),
      BottomNavigationBarItem(
          icon: const Icon(TDIcons.internet),
          label: OpenIoTHubLocalizations.of(context).tab_gateway),
      BottomNavigationBarItem(
          icon: const Icon(TDIcons.desktop),
          label: OpenIoTHubLocalizations.of(context).tab_host),
      BottomNavigationBarItem(
          icon: const Icon(TDIcons.user),
          label: OpenIoTHubLocalizations.of(context).tab_user)
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

  Future<void> _goto_local_gateway() async {
    // 如果没有登陆并且是PC平台则跳转到本地网关页面
    bool userSignedIned = await userSignedIn();
    if (!userSignedIned &&
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        timer.cancel();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return GatewayQrPage(
            key: UniqueKey(),
          );
        }));
      });
    }
  }

  //   展示首次进入应用提示的阅读隐私政策，后面则不会再提示
  void _show_read_privacy_policy() {
    // 如果没有登陆并且是PC平台则跳转到本地网关页面
    // 获取同意隐私政策状态
    bool agreed = prefs!.getBool(Agreed_Privacy_Policy) != null
        ? prefs!.getBool(Agreed_Privacy_Policy)!
        : false;
    // showToast("msg:$agreed");
    if (Platform.isAndroid && !agreed) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title:
                      Text(OpenIoTHubLocalizations.of(context).privacy_policy),
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
                                    goToURL(
                                        context,
                                        "https://docs.iothub.cloud/privacyPolicy/index.html",
                                        "《${OpenIoTHubLocalizations.of(context).privacy_policy}》");
                                  }),
                              TextButton(
                                  child: Text(
                                    OpenIoTHubLocalizations.of(context)
                                        .feedback_channels,
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => FeedbackPage(
                                                  key: UniqueKey(),
                                                )));
                                  }),
                            ],
                          ),
                          Text(OpenIoTHubLocalizations.of(context)
                              .if_you_do_not_agree_with_the_privacy_policy_please_click_to_exit_the_application)
                        ],
                      )),
                  actions: <Widget>[
                    TDButton(
                      text: OpenIoTHubLocalizations.of(context)
                          .exit_the_application,
                      size: TDButtonSize.large,
                      type: TDButtonType.fill,
                      shape: TDButtonShape.rectangle,
                      theme: TDButtonTheme.danger,
                      onTap: () {
                        SystemNavigator.pop();
                      },
                    ),
                    TDButton(
                      text: OpenIoTHubLocalizations.of(context)
                          .agree_to_the_privacy_policy,
                      size: TDButtonSize.large,
                      type: TDButtonType.fill,
                      shape: TDButtonShape.rectangle,
                      theme: TDButtonTheme.primary,
                      onTap: () async {
                        // 保存同意状态，之后不再提示,首次还会初始化微信SDK，以后直接由于有状态启动就初始化微信sdk
                        await prefs!
                            .setBool(Agreed_Privacy_Policy, true)
                            .then((_) {
                          initWechat();
                          initQQ();
                        });
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
    }
  }
}
