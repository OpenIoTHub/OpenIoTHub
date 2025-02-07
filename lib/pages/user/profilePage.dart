import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/pages/user/tools/toolsTypePage.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/openiothub_common_pages.dart';
import 'package:openiothub_common_pages/utils/goToUrl.dart';
import 'package:openiothub_constants/constants/SharedPreferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../model/custom_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  String useremail = "";
  String usermobile = "";

  String userAvatar = "";

  late List<ListTile> _listTiles;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initListTiles();
    _getUserInfo();
    return Scaffold(
        extendBody: true, //底部NavigationBar透明
        extendBodyBehindAppBar: true, //顶部Bar透明
        appBar: AppBar(
          // shadowColor: Colors.transparent,
          toolbarHeight: 0,
          backgroundColor: Provider.of<CustomTheme>(context).isLightTheme()
              ? CustomThemes.light.primaryColor
              : CustomThemes.dark.primaryColor,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
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
            return const TDDivider();
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
          ? CustomThemes.light.primaryColor
          : CustomThemes.dark.primaryColor,
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
              username,
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
            title: Text(OpenIoTHubLocalizations.of(context).profile_settings),
            leading: const Icon(TDIcons.setting, color: Colors.blueAccent),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage(
                        title: OpenIoTHubLocalizations.of(context)
                            .profile_settings,
                        key: UniqueKey(),
                      )));
            }),
        ListTile(
            //第一个功能项
            title: Text(OpenIoTHubLocalizations.of(context).profile_servers),
            leading: const Icon(TDIcons.server, color: Colors.blueAccent),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ServerPages(
                        title:
                            OpenIoTHubLocalizations.of(context).profile_servers,
                        key: UniqueKey(),
                      )));
            }),
        ListTile(
            //第一个功能项
            title: Text(OpenIoTHubLocalizations.of(context).profile_tools),
            leading: const Icon(TDIcons.tools, color: Colors.blueAccent),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ToolsTypePage()));
            }),
        ListTile(
            //第二个功能项
            title: Text(OpenIoTHubLocalizations.of(context).profile_docs),
            leading: const Icon(TDIcons.book_filled, color: Colors.blueAccent),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              String url = "https://docs.iothub.cloud/";
              goToURL(context, url,
                  OpenIoTHubLocalizations.of(context).profile_docs);
            }),
        ListTile(
            //第二个功能项
            title: Text(
                OpenIoTHubLocalizations.of(context).profile_video_tutorials),
            leading: const Icon(TDIcons.video, color: Colors.blueAccent),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              String url = "https://space.bilibili.com/1222749704";
              launchURL(url);
            }),
        ListTile(
            //第二个功能项
            title: Text(OpenIoTHubLocalizations.of(context).app_local_gateway),
            leading: const Icon(TDIcons.wifi, color: Colors.blueAccent),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GatewayQrPage(
                        key: UniqueKey(),
                      )));
            }),
        // ListTile(
        //     //第二个功能项
        //     title: Text(OpenIoTHubLocalizations.of(context).profile_feedback),
        //     leading: const Icon(Icons.feedback_outlined),
        //     trailing: const Icon(Icons.arrow_right),
        //     onTap: () {
        //       String url = "https://support.qq.com/product/657356";
        //       goToURL(context, url, OpenIoTHubLocalizations.of(context).profile_feedback);
        //     }),
        ListTile(
            //第二个功能项
            title: Text(
                OpenIoTHubLocalizations.of(context).profile_about_this_app),
            leading: const Icon(TDIcons.info_circle, color: Colors.blueAccent),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              // openiothub_mobile_service.run();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AppInfoPage(
                        key: UniqueKey(),
                      )));
            }),
        // ListTile(
        //     //第二个功能项
        //     title: Text("Share QQ"),
        //     leading: const Icon(Icons.share),
        //     trailing: const Icon(Icons.arrow_right),
        //     onTap: () async {
        //       var title = "云亿连内网穿透和智能家居管理";
        //       var description = "云亿连全平台管理您的所有智能设备和私有云";
        //       var url = "https://iothub.cloud/download.html";
        //       TencentKitPlatform.instance.shareWebpage(
        //         scene: TencentScene.kScene_QQ,
        //         title: title,
        //         // summary: description,
        //         targetUrl: url,
        //       );
        //     }),
      ];
    });
  }

  ListTile _buildListTile(int index) {
    return _listTiles[index];
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

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPreferencesKey.USER_NAME_KEY)) {
      setState(() {
        username = prefs.getString(SharedPreferencesKey.USER_NAME_KEY)!;
      });
    } else {
      setState(() {
        username = OpenIoTHubLocalizations.of(context).profile_not_logged_in;
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
