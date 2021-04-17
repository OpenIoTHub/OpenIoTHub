import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub/pages/user/LoginPage.dart';
import 'package:openiothub/pages/user/tools/toolsTypePage.dart';
import 'package:openiothub/pages/user/userInfoPage.dart';
import 'package:openiothub_common_pages/commPages/appInfo.dart';
import 'package:openiothub_common_pages/commPages/settings.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DrawerUI extends StatefulWidget {
  DrawerUI({
    Key key,
  }) : super(key: key);

  @override
  _DrawerUIState createState() => _DrawerUIState();
}

class _DrawerUIState extends State<DrawerUI> {
  String username = "未登录";
  String useremail = "";
  String usermobile = "";

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //侧边栏按钮Drawer
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            //Material内置控件
            accountName: Text(username),
            //用户名
            accountEmail: Text(usermobile != "" ? usermobile : useremail),
            //用户邮箱
            currentAccountPicture: GestureDetector(
              //用户头像
              onTap: () => () async {},
              child: CircleAvatar(
                //圆形图标控件
                backgroundImage:
                    ExactAssetImage('assets/images/leftmenu/avatars/panda.jpg'),
              ),
            ),
            decoration: BoxDecoration(
              //用一个BoxDecoration装饰器提供背景图片
              image: DecorationImage(
                fit: BoxFit.fill,
                image: ExactAssetImage(
                    'assets/images/leftmenu/background/cover_img.jpg'),
              ),
            ),
            onDetailsPressed: () => () async {},
          ),
          ListTile(
              //第一个功能项
              title: Text('账号'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                Navigator.of(context).pop();
                //  判断是否已经登录，如果已经登录就显示用户信息页面(包含退出登录)，如果没有登录就跳转到注册页面
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (prefs.containsKey(SharedPreferencesKey.USER_TOKEN_KEY)) {
                  //  已经登录
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserInfoPage()));
                } else {
                  //  未登录
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              }),
          ListTile(
              //第一个功能项
              title: Text('配置'),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsPage(
                          title: "配置",
                        )));
              }),
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ToolsTypePage()));
              }),
          ListTile(
              //第二个功能项
              title: Text('使用手册'),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Platform.isIOS
                    ? _launchURL("https://www.jianshu.com/u/b312a876d66e")
                    : _goToURL(context,
                        "https://www.jianshu.com/u/b312a876d66e", "使用手册");
              }),
          ListTile(
              //第二个功能项
              title: Text('社区反馈'),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Platform.isIOS
                    ? _launchURL("https://wulian.work")
                    : _goToURL(context, "https://wulian.work", "社区反馈");
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

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPreferencesKey.USER_NAME_KEY)) {
      setState(() {
        username = prefs.getString(SharedPreferencesKey.USER_NAME_KEY);
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.USER_EMAIL_KEY)) {
      setState(() {
        useremail = prefs.getString(SharedPreferencesKey.USER_EMAIL_KEY);
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.USER_MOBILE_KEY)) {
      setState(() {
        usermobile = prefs.getString(SharedPreferencesKey.USER_MOBILE_KEY);
      });
    }
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

_goToURL(BuildContext context, String url, title) async {
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
      body:
          WebView(initialUrl: url, javascriptMode: JavascriptMode.unrestricted),
    );
  }));
}
