import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/user/LoginPage.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accountSecurityPage.dart';

import 'package:openiothub_common_pages/openiothub_common_pages.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String username = "";
  String usermobile = "";
  String useremail = "";

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(OpenIoTHubCommonLocalizations.of(context).user_info),
        ),
        body: ListView(children: <Widget>[
          ListTile(
            //第一个功能项
            title: Text('${OpenIoTHubCommonLocalizations.of(context).username}：$username'),
            // trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
            //第二个功能项
            title: Text('${OpenIoTHubCommonLocalizations.of(context).user_mobile}：$usermobile'),
            // trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
            //第三个功能项
            title: Text('${OpenIoTHubCommonLocalizations.of(context).user_email}：$useremail'),
            // trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
              //第四个功能项
              title: Text(OpenIoTHubCommonLocalizations.of(context).account_and_safety),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AccountSecurityPage();
                }));
              }),
          TextButton(
              onPressed: () {
                _logOut();
              },
              child: Text(
                OpenIoTHubCommonLocalizations.of(context).logout,
                style: TextStyle(
                  color: Colors.red,
                ),
              )),
        ]));
  }

  Future<void> _getUserInfo() async {
    bool b = await userSignedIn();
    if (!b) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }
    //从网络同步一遍到本地
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfo userInfo = await UserManager.GetUserInfo();
    await prefs.setString(SharedPreferencesKey.USER_NAME_KEY, userInfo.name);
    await prefs.setString(SharedPreferencesKey.USER_EMAIL_KEY, userInfo.email);
    await prefs.setString(
        SharedPreferencesKey.USER_MOBILE_KEY, userInfo.mobile);
    await prefs.setString(
        SharedPreferencesKey.USER_AVATAR_KEY, userInfo.avatar);
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

  Future<void> _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferencesKey.USER_TOKEN_KEY);
    await prefs.remove(SharedPreferencesKey.USER_NAME_KEY);
    await prefs.remove(SharedPreferencesKey.USER_EMAIL_KEY);
    await prefs.remove(SharedPreferencesKey.USER_MOBILE_KEY);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}
