import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub/generated/l10n.dart';
import 'package:openiothub/pages/mdnsService/mdnsServiceListPage.dart';
import 'package:openiothub/pages/session/sessionListPage.dart';
import 'package:openiothub/pages/user/profilePage.dart';
import 'package:openiothub_common_pages/wifiConfig/smartConfigTool.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../commonDevice/commonDeviceListPage.dart';
import '../commonPages/scanQR.dart';

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //悬浮按钮
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.add),
        //   shape: const CircleBorder(),
        //   elevation: 2.0,
        //   tooltip: 'Add Device',
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return SmartConfigTool(
        //             title: "添加设备",
        //             needCallBack: true,
        //             key: UniqueKey(),
        //           );
        //         },
        //       ),
        //     );
        //   },
        // ),
        floatingActionButton: _build_peedDial(),
        bottomNavigationBar: _buildBottomNavigationBar(_currentIndex));
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
        return SessionListPage(
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

  Widget _buildBottomNavigationBar(int index) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      height: 55,
      padding: const EdgeInsets.only(top: 1.5,bottom: 1.5),
      // color: Provider.of<CustomTheme>(context).isLightTheme()
      //     ? CustomThemes.light.scaffoldBackgroundColor
      //     : CustomThemes.dark.scaffoldBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBotomItem(_currentIndex, 0, Icons.home, S.current.tab_smart),
          _buildBotomItem(
              _currentIndex, 1, Icons.airplay, S.current.tab_gateway),
          _buildBotomItem(_currentIndex, -1, null, ""),
          _buildBotomItem(_currentIndex, 2, Icons.print, S.current.tab_host),
          _buildBotomItem(_currentIndex, 3, Icons.person, S.current.tab_user),
        ],
      ),
    );
  }

  _buildBotomItem(
      int selectIndex, int index, IconData? iconData, String title) {
    //未选中状态的样式
    TextStyle textStyle = const TextStyle(fontSize: 12.0, color: Colors.grey);
    MaterialColor? iconColor = Colors.grey;
    double iconSize = 20;
    EdgeInsetsGeometry padding = const EdgeInsets.only(top: 3.0,bottom: 1.5);

    if (selectIndex == index) {
      //选中状态的文字样式
      textStyle = TextStyle(fontSize: 13.0, color: _activeColor);
      //选中状态的按钮样式
      iconColor = _activeColor as MaterialColor?;
      iconSize = 25;
      padding = const EdgeInsets.only(top: 1.5,bottom: 1.5);
    }
    Widget padItem = const SizedBox();
    if (iconData != null) {
      padItem = Padding(
        padding: padding,
        child: Center(
          child: Column(
            children: <Widget>[
              Icon(
                iconData,
                color: iconColor,
                size: iconSize,
              ),
              Text(
                title,
                style: textStyle,
              )
            ],
          ),
        ),
      );
    }
    Widget item = Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          if (index != _currentIndex && index != -1) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        child: SizedBox(
          // height: 52,
          child: padItem,
        ),
      ),
    );
    return item;
  }

  _build_peedDial() {
    var speedDial = SpeedDial(
      icon: Icons.add,
      spacing: 10,
      spaceBetweenChildren: 5,
      children: [
        SpeedDialChild(
          elevation: 2,
          child: const Icon(Icons.wifi_tethering),
          label: S.current.config_device_wifi,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SmartConfigTool(
                    title: S.current.config_device_wifi,
                    needCallBack: true,
                    key: UniqueKey(),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
    //只有移动平台才支持扫码
    if (Platform.isAndroid || Platform.isIOS) {
      speedDial.children.add(SpeedDialChild(
        elevation: 2,
        child: const Icon(Icons.settings_overscan),
        label: S.current.scan_QR,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const ScanQRPage();
              },
            ),
          );
        },
      ));
    }
    return speedDial;
  }
}
