import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/pages/user/LoginPage.dart';
import 'package:openiothub/pages/user/tools/toolsTypePage.dart';
import 'package:openiothub/pages/user/userInfoPage.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/appInfo.dart';
import 'package:openiothub_common_pages/commPages/settings.dart';
import 'package:openiothub_constants/constants/SharedPreferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "未登录";
  String useremail = "";
  String usermobile = "";

  String userAvatar;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 0,
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader();
            }
            index -= 1;
            return _buildListTile(index);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: 6,
        ));
  }

  _login() async {
    bool userSignedIned = await userSignedIn();
    if (userSignedIned) {
      //  已经登录
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UserInfoPage()))
          .then((value) => _getUserInfo());
    } else {
      //  未登录
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()))
          .then((value) => _getUserInfo());
    }
  }

  Container _buildHeader() {
    return Container(
      color: Provider.of<CustomTheme>(context).themeValue == "dark"
          ? CustomThemes.dark.accentColor
          : CustomThemes.light.accentColor,
      height: 150.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: userAvatar != null
                  ? Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xffffffff),
                          width: 2.0,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(userAvatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/images/leftmenu/avatars/panda.jpg',
                      width: 60.0,
                      height: 60.0,
                    ),
              onTap: () async {
                _login();
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              username ??= '点击头像登录',
              style: TextStyle(color: Color(0xffffffff)),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(int _index) {
    List<ListTile> _listTiles = <ListTile>[
      ListTile(
          //第一个功能项
          title: Text('配置'),
          leading: Icon(Icons.settings),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsPage(
                      title: "配置",
                    )));
          }),
      ListTile(
          //第一个功能项
          title: Text('工具'),
          leading: Icon(Icons.pan_tool),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ToolsTypePage()));
          }),
      ListTile(
          //第二个功能项
          title: Text('使用手册'),
          leading: Icon(Icons.add_chart),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            Platform.isIOS
                ? _launchURL("https://www.jianshu.com/u/b312a876d66e")
                : _goToURL(
                    context, "https://www.jianshu.com/u/b312a876d66e", "使用手册");
          }),
      ListTile(
          //第二个功能项
          title: Text('社区反馈'),
          leading: Icon(Icons.all_inclusive),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            Platform.isIOS
                ? _launchURL("https://wulian.work")
                : _goToURL(context, "https://wulian.work", "社区反馈");
          }),
      ListTile(
          //第二个功能项
          title: Text('关于本软件'),
          leading: Icon(Icons.info),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AppInfoPage()));
          }),
    ];
    return _listTiles[_index];
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
        body: WebView(
            initialUrl: url, javascriptMode: JavascriptMode.unrestricted),
      );
    }));
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPreferencesKey.USER_NAME_KEY)) {
      setState(() {
        username = prefs.getString(SharedPreferencesKey.USER_NAME_KEY);
      });
    } else {
      setState(() {
        username = "";
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.USER_EMAIL_KEY)) {
      setState(() {
        useremail = prefs.getString(SharedPreferencesKey.USER_EMAIL_KEY);
      });
    } else {
      setState(() {
        useremail = "未登录";
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.USER_MOBILE_KEY)) {
      setState(() {
        usermobile = prefs.getString(SharedPreferencesKey.USER_MOBILE_KEY);
      });
    } else {
      setState(() {
        usermobile = "";
      });
    }
  }
}
