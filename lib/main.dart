import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/pages/mdnsService/mdnsServiceListPage.dart';
import 'package:openiothub/pages/session/sessionListPage.dart';
import 'package:openiothub/pages/user/profilePage.dart';
import 'package:openiothub/util/InitAllConfig.dart';
import 'package:openiothub_common_pages/wifiConfig/smartConfigTool.dart';
import 'package:openiothub_constants/constants/Config.dart';
import 'package:provider/provider.dart';

import './pages/commonDevice/commonDeviceListPage.dart';

void main() {
  FlutterNatcloudService.start();
  Future.delayed(Duration(seconds: 1), () {
    InitAllConfig();
  });
  final server =
      Jaguar(address: Config.webStaticIp, port: Config.webStaticPort);
  server.addRoute(serveFlutterAssets());
  server.serve(logRequests: true).then((v) {
    server.log.onRecord.listen((r) => debugPrint("==serve-log：$r"));
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomTheme()),
      ],
      child: MyApp(),
    ),
    // MyApp()
  );
  //安卓透明状态栏
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '云易连',
      theme: CustomThemes.light,
      darkTheme: CustomThemes.dark,
      home: MyHomePage(title: '云易连'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _activeColor = Colors.orange;
  int _currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        // drawer: DrawerUI(),
        body: _buildBody(_currentIndex),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //悬浮按钮
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SmartConfigTool(
                    title: "添加设备",
                    needCallBack: true,
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(_currentIndex));
  }

//通过index判断展现的类型
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return MdnsServiceListPage(title: "智能");
        break;
      case 1:
        return SessionListPage(title: "网关");
        break;
      case 2:
        return CommonDeviceListPage(title: "主机");
        break;
      case 3:
        // return UserInfoPage();
        return ProfilePage();
        break;
    }
    return Text("没有匹配的内容");
  }

  Widget _buildBottomNavigationBar(int index) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Provider.of<CustomTheme>(context).isLightTheme()
          ? CustomThemes.light.scaffoldBackgroundColor
          : CustomThemes.dark.scaffoldBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBotomItem(_currentIndex, 0, Icons.home, "智能"),
          _buildBotomItem(_currentIndex, 1, Icons.airplay, "网关"),
          _buildBotomItem(_currentIndex, -1, null, "null"),
          _buildBotomItem(_currentIndex, 2, Icons.print, "主机"),
          _buildBotomItem(_currentIndex, 3, Icons.person, "我的"),
        ],
      ),
    );
  }

  _buildBotomItem(int selectIndex, int index, IconData iconData, String title) {
    //未选中状态的样式
    TextStyle textStyle = TextStyle(fontSize: 12.0, color: Colors.grey);
    MaterialColor iconColor = Colors.grey;
    double iconSize = 20;
    EdgeInsetsGeometry padding = EdgeInsets.only(top: 8.0);

    if (selectIndex == index) {
      //选中状态的文字样式
      textStyle = TextStyle(fontSize: 13.0, color: _activeColor);
      //选中状态的按钮样式
      iconColor = _activeColor;
      iconSize = 25;
      padding = EdgeInsets.only(top: 6.0);
    }
    Widget padItem = SizedBox();
    if (iconData != null) {
      padItem = Padding(
        padding: padding,
        child: Container(
          color: Provider.of<CustomTheme>(context).isLightTheme()
              ? CustomThemes.light.scaffoldBackgroundColor
              : CustomThemes.dark.scaffoldBackgroundColor,
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
        ),
      );
    }
    Widget item = Expanded(
      flex: 1,
      child: new GestureDetector(
        onTap: () {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        child: SizedBox(
          height: 52,
          child: padItem,
        ),
      ),
    );
    return item;
  }
}
