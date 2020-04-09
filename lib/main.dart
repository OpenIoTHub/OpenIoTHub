import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';

import 'package:nat_explorer/constants/Config.dart';
import './pages/commonDevice/commonDeviceListPage.dart';
import 'package:nat_explorer/pages/mdnsService/mdnsServiceListPage.dart';
import 'package:nat_explorer/pages/openWithChoice/sshWeb/fileExplorer/services/connection_model.dart';
import 'package:nat_explorer/model/custom_theme.dart';
import 'package:nat_explorer/pages/session/sessionListPage.dart';
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
      title: '云易连',
      theme: Provider.of<CustomTheme>(context).themeValue == "dark"
          ? CustomThemes.dark
          : CustomThemes.light,
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
  Color _inactiveColor = Colors.black;
  Color _activeColor = Colors.orange;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _activeColor = Provider.of<CustomTheme>(context).themeValue == "dark"
        ? CustomThemes.dark.accentColor
        : CustomThemes.light.accentColor;
    return Scaffold(
        body: _buildBody(_currentIndex),
        bottomNavigationBar: _buildBottomNavigationBar(_currentIndex));
  }

//通过index判断展现的类型
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return SessionListPage(title: "网关列表");
        break;
      case 1:
        return CommonDeviceListPage(title: "主机");
        break;
      case 2:
        return MdnsServiceListPage(title: "设备和服务");
        break;
      case 3:
        return MyInfoPage();
        break;
    }
    return Text("没有匹配的内容");
  }

  Widget _buildBottomNavigationBar(int index) {
    return Platform.isIOS?
    BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? _activeColor : _inactiveColor,
            ),
            title: Text(
              '网关',
              style: TextStyle(
                  color: _currentIndex == 0 ? _activeColor : _inactiveColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.airplay,
              color: _currentIndex == 1 ? _activeColor : _inactiveColor,
            ),
            title: Text(
              '主机',
              style: TextStyle(
                  color: _currentIndex == 1 ? _activeColor : _inactiveColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.print,
              color: _currentIndex == 2 ? _activeColor : _inactiveColor,
            ),
            title: Text(
              '智能',
              style: TextStyle(
                  color: _currentIndex == 2 ? _activeColor : _inactiveColor),
            )),
      ],
      currentIndex: index,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    )
    :
    BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? _activeColor : _inactiveColor,
            ),
            title: Text(
              '网络',
              style: TextStyle(
                  color: _currentIndex == 0 ? _activeColor : _inactiveColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.airplay,
              color: _currentIndex == 1 ? _activeColor : _inactiveColor,
            ),
            title: Text(
              '主机',
              style: TextStyle(
                  color: _currentIndex == 1 ? _activeColor : _inactiveColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.print,
              color: _currentIndex == 2 ? _activeColor : _inactiveColor,
            ),
            title: Text(
              '智能',
              style: TextStyle(
                  color: _currentIndex == 2 ? _activeColor : _inactiveColor),
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: _currentIndex == 3 ? _activeColor : _inactiveColor,
            ),
            title: Text(
              '我',
              style: TextStyle(
                  color: _currentIndex == 3 ? _activeColor : _inactiveColor),
            )),
      ],
      currentIndex: index,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    )
    ;
  }
}
