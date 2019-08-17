import 'package:flutter/material.dart';

import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';

import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/pages/openWithChoice/sshWeb/fileExplorer/services/connection_model.dart';
import 'package:nat_explorer/pages/openWithChoice/sshWeb/fileExplorer/shared/custom_theme.dart';
import 'package:nat_explorer/pages/session/sessionListPage.dart';
import 'package:nat_explorer/pages/device/deviceTypePage.dart';
import 'package:nat_explorer/pages/user/accountPage.dart';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

import 'package:provider/provider.dart';

void main() {
  FlutterNatcloudService.start();
  final server =
      Jaguar(address: Config.webStaticIp, port: Config.webStaticPort);
  server.addRoute(serveFlutterAssets());
  server.serve(logRequests: true).then((v) {
    server.log.onRecord.listen((r) => debugPrint("==serve-log：$r"));
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ConnectionModel()),
        ChangeNotifierProvider(builder: (context) => CustomTheme()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '内网穿透',
      theme: Provider.of<CustomTheme>(context).themeValue == "dark"
          ? CustomThemes.dark
          : CustomThemes.light,
      home: MyHomePage(title: '内网访问工具'),
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
//  final _bottomNavigationColor = Colors.blue;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(_currentIndex),
        bottomNavigationBar: _buildBottomNavigationBar(_currentIndex));
  }

//通过index判断展现的类型
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return SessionListPage(title: "网络列表");
        break;
      case 1:
        return DiscoveryPage();
        break;
      case 2:
        return MyInfoPage();
        break;
    }
    return Text("没有匹配的内容");
  }

  Widget _buildBottomNavigationBar(int index) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
//              color: _bottomNavigationColor,
            ),
            title: Text(
              '网络',
//              style: TextStyle(color: _bottomNavigationColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.airplay,
//              color: _bottomNavigationColor,
            ),
            title: Text(
              '设备',
//              style: TextStyle(color: _bottomNavigationColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
//              color: _bottomNavigationColor,
            ),
            title: Text(
              '我',
//              style: TextStyle(color: _bottomNavigationColor),
            )),
      ],
      currentIndex: index,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
