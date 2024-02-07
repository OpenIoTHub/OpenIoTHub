import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openiothub/generated/l10n.dart';
import 'package:openiothub/model/custom_theme.dart';
import 'package:openiothub/pages/user/tools/toolsTypePage.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_constants/constants/SharedPreferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = S.current.profile_not_logged_in;
  String useremail = "";
  String usermobile = "";

  String userAvatar ="";

  late List<ListTile> _listTiles;

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
            return const Divider();
          },
          itemCount: _listTiles == null ? 1 : _listTiles.length + 1,
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
          ? CustomThemes.light.primaryColorLight
          : CustomThemes.dark.primaryColorDark,
      height: 150.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: userAvatar != ""
                  ? Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xffffffff),
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
                          color: const Color(0xffffffff),
                          width: 2.0,
                        ),
                        image: const DecorationImage(
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
            const SizedBox(
              height: 10.0,
            ),
            Text(
              username ??= S.current.profile_click_avatar_to_sign_in,
              style: const TextStyle(color: Color(0xffffffff)),
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
            leading: const Icon(Icons.settings),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage(
                        title: S.current.profile_settings,
                        key: UniqueKey(),
                      )));
            }),
        ListTile(
            //第一个功能项
            title: Text(S.current.profile_servers),
            leading: const Icon(Icons.send_rounded),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ServerPages(
                        title: S.current.profile_servers,
                        key: UniqueKey(),
                      )));
            }),
        ListTile(
            //第一个功能项
            title: Text(S.current.profile_tools),
            leading: const Icon(Icons.pan_tool),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ToolsTypePage()));
            }),
        ListTile(
            //第二个功能项
            title: Text(S.current.profile_docs),
            leading: const Icon(Icons.add_chart),
            trailing: const Icon(Icons.arrow_right),
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
            title: Text(S.current.app_local_gateway),
            leading: Icon(Icons.all_inclusive),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GatewayQrPage(
                    key: UniqueKey(),
                  )));
            }),
        ListTile(
            //第二个功能项
            title: Text(S.current.profile_about_this_app),
            leading: const Icon(Icons.info),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              // openiothub_mobile_service.run();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AppInfoPage(
                        key: UniqueKey(),
                      )));
            }),
      ];
    });
  }

  ListTile _buildListTile(int _index) {
    return _listTiles[_index];
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }

  _goToURL(BuildContext context, String url, title) async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _launchURL(url);
      return;
    }
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
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
        body: WebViewWidget(controller: controller),
      );
    }));
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPreferencesKey.USER_NAME_KEY)) {
      setState(() {
        username = prefs.getString(SharedPreferencesKey.USER_NAME_KEY)!;
      });
    } else {
      setState(() {
        username = "";
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.USER_EMAIL_KEY)) {
      setState(() {
        useremail = prefs.getString(SharedPreferencesKey.USER_EMAIL_KEY)!;
      });
    } else {
      setState(() {
        useremail = "";
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.USER_MOBILE_KEY)) {
      setState(() {
        usermobile = prefs.getString(SharedPreferencesKey.USER_MOBILE_KEY)!;
      });
    } else {
      setState(() {
        usermobile = "";
      });
    }
  }
}
