import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/common_pages/user/login_page.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'account_security_page.dart';

import 'package:openiothub/common_pages/openiothub_common_pages.dart';

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
    UserInfo userInfo = await UserManager.getUserInfo();
    await prefs.setString(SharedPreferencesKey.userNameKey, userInfo.name);
    await prefs.setString(SharedPreferencesKey.userEmailKey, userInfo.email);
    await prefs.setString(
        SharedPreferencesKey.userMobileKey, userInfo.mobile);
    await prefs.setString(
        SharedPreferencesKey.userAvatarKey, userInfo.avatar);
    if (prefs.containsKey(SharedPreferencesKey.userNameKey)) {
      setState(() {
        username = prefs.getString(SharedPreferencesKey.userNameKey)!;
      });
    } else {
      setState(() {
        username = "";
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.userEmailKey)) {
      setState(() {
        useremail = prefs.getString(SharedPreferencesKey.userEmailKey)!;
      });
    } else {
      setState(() {
        useremail = "";
      });
    }
    if (prefs.containsKey(SharedPreferencesKey.userMobileKey)) {
      setState(() {
        usermobile = prefs.getString(SharedPreferencesKey.userMobileKey)!;
      });
    } else {
      setState(() {
        usermobile = "";
      });
    }
  }

  Future<void> _logOut() async {
    // 清除本地存储的用户信息
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferencesKey.userTokenKey);
    await prefs.remove(SharedPreferencesKey.userNameKey);
    await prefs.remove(SharedPreferencesKey.userEmailKey);
    await prefs.remove(SharedPreferencesKey.userMobileKey);
    
    // 清除路由栈并跳转到登录页面
    // 路由拦截器会监听认证状态变化并自动处理
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false, // 清除所有路由
    );
  }
}
