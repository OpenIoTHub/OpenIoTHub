import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';

import 'package:modules/constants/Config.dart';
import 'package:modules/pages/commPages/appInfo.dart';
import 'package:openiothub/pages/user/tools/toolsTypePage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './pages/commonDevice/commonDeviceListPage.dart';
import 'package:openiothub/pages/mdnsService/mdnsServiceListPage.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/pages/session/sessionListPage.dart';
import 'package:openiothub/pages/user/accountPage.dart';
import 'package:openiothub/util/InitAllConfig.dart';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

import 'package:provider/provider.dart';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        key: _scaffoldKey,
        drawer: _buildDrawer(),
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
    return BottomNavigationBar(
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
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      //侧边栏按钮Drawer
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            //Material内置控件
//            accountName: Text('CYC'), //用户名
//            accountEmail: Text('example@126.com'),  //用户邮箱
//            currentAccountPicture: GestureDetector( //用户头像
//              onTap: () => print('current user'),
//              child: CircleAvatar(    //圆形图标控件
//                backgroundImage: NetworkImage('https://upload.jianshu.io/users/upload_avatars/7700793/dbcf94ba-9e63-4fcf-aa77-361644dd5a87?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),//图片调取自网络
//              ),
//            ),
//            otherAccountsPictures: <Widget>[    //粉丝头像
//              GestureDetector(    //手势探测器，可以识别各种手势，这里只用到了onTap
//                onTap: () => print('other user'), //暂且先打印一下信息吧，以后再添加跳转页面的逻辑
//                child: CircleAvatar(
//                  backgroundImage: NetworkImage('https://upload.jianshu.io/users/upload_avatars/10878817/240ab127-e41b-496b-80d6-fc6c0c99f291?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),
//                ),
//              ),
//              GestureDetector(
//                onTap: () => print('other user'),
//                child: CircleAvatar(
//                  backgroundImage: NetworkImage('https://upload.jianshu.io/users/upload_avatars/8346438/e3e45f12-b3c2-45a1-95ac-a608fa3b8960?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),
//                ),
//              ),
//            ],
            decoration: BoxDecoration(
              //用一个BoxDecoration装饰器提供背景图片
              image: DecorationImage(
                fit: BoxFit.fill,
                image: ExactAssetImage('assets/images/cover_img.jpg'),
              ),
            ),
          ),
          ListTile(
              //第一个功能项
              title: Text('工具'),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToolsTypePage()));
              }),
          ListTile(
            //TODO 管理MQTT服务器，以从MQTT服务器获取和操控设备
              title: Text('MQTT服务器'),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
              }),
          ListTile(
              //第二个功能项
              title: Text('使用手册'),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Platform.isIOS
                    ? _launchURL("https://www.jianshu.com/u/b312a876d66e")
                    : _goToURL(
                        "https://www.jianshu.com/u/b312a876d66e", "使用手册");
              }),
          ListTile(
              //第二个功能项
              title: Text('关于本软件'),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AppInfoPage()));
              }),
          Divider(), //分割线控件
          ListTile(
            //退出按钮
            title: Text('Close'),
            trailing: Icon(Icons.cancel),
            onTap: () => Navigator.of(context).pop(), //点击后收起侧边栏
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  _goToURL(String url, title) async {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return Scaffold(
        appBar: AppBar(title: Text(title), actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: () {
                _launchURL(url);
              })
        ]),
        body: WebView(
            initialUrl: url, javascriptMode: JavascriptMode.unrestricted),
      );
    }));
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }
}
