import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/app/providers/auth_provider.dart';
import 'package:openiothub/router/core/app_routes.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:openiothub/pages/common/openiothub_common_pages.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => UserInfoPageState();
}

class UserInfoPageState extends State<UserInfoPage> {
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
          title: Text(OpenIoTHubLocalizations.of(context).user_info),
        ),
        body: ListView(children: <Widget>[
          ListTile(
            //第一个功能项
            title: Text('${OpenIoTHubLocalizations.of(context).username}：$username'),
            // trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
            //第二个功能项
            title: Text('${OpenIoTHubLocalizations.of(context).user_mobile}：$usermobile'),
            // trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
            //第三个功能项
            title: Text('${OpenIoTHubLocalizations.of(context).user_email}：$useremail'),
            // trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
              //第四个功能项
              title: Text(OpenIoTHubLocalizations.of(context).account_and_safety),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                context.push(AppRoutes.accountSecurity);
              }),
          TextButton(
              onPressed: () {
                _logOut();
              },
              child: Text(
                OpenIoTHubLocalizations.of(context).logout,
                style: TextStyle(
                  color: Colors.red,
                ),
              )),
        ]));
  }

  Future<void> _getUserInfo() async {
    var signedIn = await userSignedIn();
    if (!mounted) return;
    if (!signedIn) {
      await context.push<void>(AppRoutes.login);
      if (!mounted) return;
      signedIn = await userSignedIn();
      if (!signedIn) return;
    }
    //从网络同步一遍到本地
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfo userInfo = await UserManager.getUserInfo();
    if (!mounted) return;
    await prefs.setString(SharedPreferencesKey.userNameKey, userInfo.name);
    await prefs.setString(SharedPreferencesKey.userEmailKey, userInfo.email);
    await prefs.setString(
        SharedPreferencesKey.userMobileKey, userInfo.mobile);
    await prefs.setString(
        SharedPreferencesKey.userAvatarKey, userInfo.avatar);
    if (!mounted) return;
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
    await prefs.remove(SharedPreferencesKey.userNameKey);
    await prefs.remove(SharedPreferencesKey.userEmailKey);
    await prefs.remove(SharedPreferencesKey.userMobileKey);

    if (!mounted) return;
    await context.read<AuthProvider>().clearToken();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }
}
