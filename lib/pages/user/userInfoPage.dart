import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_manager_grpc_api/pb/common.pb.dart';
import 'package:openiothub_api/api/IoTManager/UserManager.dart';
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
              onTap: () async {
                _modifyInfo("用户名");
              }),
          ListTile(
              //第一个功能项
              title: Text('手机号：$usermobile'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo("手机号");
              }),
          ListTile(
              //第一个功能项
              title: Text('邮箱：$useremail'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo("邮箱");
              }),
          ListTile(
              //第一个功能项
              title: Text('修改密码'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo("密码");
              }),
          TextButton(
              onPressed: () {
                _logOut();
              },
              child: Text(
                "退出登录",
                style: TextStyle(
                  color: Colors.red,
                ),
              ))
        ]));
  }

  Future<void> _getUserInfo() async {
    //从网络同步一遍到本地
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfo userInfo = await UserManager.GetUserInfo();
    await prefs.setString(
        SharedPreferencesKey.USER_NAME_KEY,userInfo.name);
    await prefs.setString(
        SharedPreferencesKey.USER_EMAIL_KEY,userInfo.email);
    await prefs.setString(
        SharedPreferencesKey.USER_MOBILE_KEY,userInfo.mobile);
    await prefs.setString(
        SharedPreferencesKey.USER_AVATAR_KEY,userInfo.avatar);
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

  Future<void> _modifyInfo(String type) async {
    TextEditingController _new_value_controller =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("修改：$type"),
                content: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _new_value_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '请输入新的值',
                        helperText: '新值',
                      ),
                      obscureText: type == "密码",
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("修改"),
                    onPressed: () async {
                      StringValue stringValue = StringValue();
                      stringValue.value = _new_value_controller.text;
                      switch (type) {
                        case "用户名":
                          OperationResponse operationResponse =
                              await UserManager.UpdateUserNanme(stringValue);
                          break;
                        case "手机号":
                          OperationResponse operationResponse =
                              await UserManager.UpdateUserMobile(stringValue);
                          break;
                        case "邮箱":
                          OperationResponse operationResponse =
                              await UserManager.UpdateUserEmail(stringValue);
                          break;
                        case "密码":
                          OperationResponse operationResponse =
                              await UserManager.UpdateUserPassword(stringValue);
                          break;
                      }
                      Navigator.of(context).pop();
                      _getUserInfo();
                    },
                  )
                ]));
  }
}
