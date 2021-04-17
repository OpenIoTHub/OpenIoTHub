import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          title: Text("用户信息"),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              //第一个功能项
              title: Text('用户名：$username'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {}),
          ListTile(
              //第一个功能项
              title: Text('手机号：$usermobile'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {}),
          ListTile(
              //第一个功能项
              title: Text('邮箱：$useremail'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {}),
          TextButton(
              onPressed: () {
                _logOut();
              },
              child: Text("退出登录", style: TextStyle(color: Colors.red,),))
        ]));
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

  Future<void> _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferencesKey.USER_TOKEN_KEY);
    await prefs.remove(SharedPreferencesKey.USER_NAME_KEY);
    await prefs.remove(SharedPreferencesKey.USER_EMAIL_KEY);
    await prefs.remove(SharedPreferencesKey.USER_MOBILE_KEY);
    Navigator.of(context).pop();
  }
}
