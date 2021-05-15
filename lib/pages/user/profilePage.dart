import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_natcloud_service/flutter_natcloud_service.dart';
import 'package:openiothub/generated/l10n.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/pages/user/tools/toolsTypePage.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/commPages/appInfo.dart';
import 'package:openiothub_common_pages/commPages/settings.dart';
import 'package:openiothub_common_pages/user/LoginPage.dart';
import 'package:openiothub_common_pages/user/userInfoPage.dart';
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
  String username = S.current.profile_not_logged_in;
  String useremail = "";
  String usermobile = "";

  String userAvatar;

  List<ListTile> _listTiles;

  @override
  void initState() {
    super.initState();
    _initListTiles();
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
          itemCount: _listTiles == null? 1 : _listTiles.length + 1,
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
      color: Provider.of<CustomTheme>(context).isLightTheme()
          ? CustomThemes.light.accentColor
          : CustomThemes.dark.accentColor,
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
                  : Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xffffffff),
                          width: 2.0,
                        ),
                        image: DecorationImage(
                          image: ExactAssetImage(
                              "assets/images/leftmenu/avatars/panda.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              onTap: () async {
                _login();
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              username ??= S.current.profile_click_avatar_to_sign_in,
              style: TextStyle(color: Color(0xffffffff)),
            ),
          ],
        ),
      ),
    );
  }

  _initListTiles() {
    setState(() {
      _listTiles = <ListTile>[
        ListTile(
          //第一个功能项
            title: Text(S.current.profile_settings),
            leading: Icon(Icons.settings),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    title: S.current.profile_settings,
                  )));
            }),
        ListTile(
          //第一个功能项
            title: Text(S.current.profile_tools),
            leading: Icon(Icons.pan_tool),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ToolsTypePage()));
            }),
        ListTile(
          //第二个功能项
            title: Text(S.current.profile_docs),
            leading: Icon(Icons.add_chart),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              String url = "https://b23.tv/wVAMWn";
              Platform.isIOS
                  ? _goToURL(context, url, S.current.profile_docs)
                  : _goToURL(context, url, S.current.profile_docs);
            }),
        // ListTile(
        //     //第二个功能项
        //     title: Text('社区反馈'),
        //     leading: Icon(Icons.all_inclusive),
        //     trailing: Icon(Icons.arrow_right),
        //     onTap: () {
        //       Platform.isIOS
        //           ? _goToURL(context, "https://wulian.work", "社区反馈")
        //           : _goToURL(context, "https://wulian.work", "社区反馈");
        //     }),
        ListTile(
          //第二个功能项
            title: Text(S.current.profile_about_this_app),
            leading: Icon(Icons.info),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              FlutterNatcloudService.start();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AppInfoPage()));
            }),
      ];
    });
  }

  ListTile _buildListTile(int _index) {
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
          // IconButton(
          //     icon: Icon(
          //       Icons.open_in_browser,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       _launchURL(url);
          //     })
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
        username = null;
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.USER_EMAIL_KEY)) {
      setState(() {
        useremail = prefs.getString(SharedPreferencesKey.USER_EMAIL_KEY);
      });
    } else {
      setState(() {
        useremail = "";
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
