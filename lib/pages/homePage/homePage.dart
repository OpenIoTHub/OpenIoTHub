import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub/generated/l10n.dart';
import 'package:openiothub/pages/mdnsService/mdnsServiceListPage.dart';
import 'package:openiothub/pages/user/profilePage.dart';
import 'package:openiothub_api/utils/check.dart';
import 'package:openiothub_common_pages/gateway/GatewayQrPage.dart';

import '../commonDevice/commonDeviceListPage.dart';
import '../gateway/gatewayListPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required Key key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final Color _activeColor = Colors.orange;
  int _currentIndex = 0;
  Timer? _timer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        // showToast( "程序状态：${state.toString()}");
        // if (Platform.isIOS) {
        //   // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        //   //   exit(0);
        //   // });
        //   exit(0);
        // }
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        // showToast( "程序状态：${state.toString()}");
        if (_timer != null) {
          _timer!.cancel();
        }
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        // showToast( "程序状态：${state.toString()}");
        if (Platform.isIOS) {
          // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
          //   exit(0);
          // });
          // exit(0);
        }
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
    _goto_local_gateway();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: S.current.tab_smart,
          key: UniqueKey(),
        );
        break;
      case 1:
        return GatewayListPage(
          title: S.current.tab_gateway,
          key: UniqueKey(),
        );
        break;
      case 2:
        return CommonDeviceListPage(
          title: S.current.tab_host,
          key: UniqueKey(),
        );
        break;
      case 3:
        // return UserInfoPage();
        return const ProfilePage();
        break;
    }
    return MdnsServiceListPage(
      title: S.current.tab_smart,
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

  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
        icon: const Icon(Icons.home), label: S.current.tab_smart),
    BottomNavigationBarItem(
        icon: const Icon(Icons.airplay), label: S.current.tab_gateway),
    BottomNavigationBarItem(
        icon: const Icon(Icons.print), label: S.current.tab_host),
    BottomNavigationBarItem(
        icon: const Icon(Icons.person), label: S.current.tab_user)
  ];

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: bottomNavItems,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        _changePage(index);
      },
    );
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
}
