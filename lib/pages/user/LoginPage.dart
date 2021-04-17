import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_manager_grpc_api/pb/userManager.pb.dart';
import 'package:openiothub/pages/user/RegisterPage.dart';
import 'package:openiothub/pages/user/userInfoPage.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> {
//  New
  final TextEditingController _usermobile = TextEditingController(text: "");
  final TextEditingController _userpassword = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("登录"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _usermobile,
                  decoration: InputDecoration(labelText: '手机号'),
                  onChanged: (String v) {},
                ),
                TextField(
                  controller: _userpassword,
                  decoration: InputDecoration(labelText: '用户密码'),
                  obscureText: true,
                  onChanged: (String v) {},
                ),
                TextButton(child: Text('没有账号?点我注册'), onPressed: () async {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                }),
                TextButton(
                    child: Text('登录'),
                    onPressed: () async {
                      LoginInfo loginInfo = LoginInfo();
                      loginInfo.userMobile = _usermobile.text;
                      loginInfo.password = _userpassword.text;
                      UserLoginResponse userLoginResponse =
                          await UserManager.LoginWithUserLoginInfo(loginInfo);
                      if (userLoginResponse.code == 0) {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        await prefs.setString(
                            SharedPreferencesKey.USER_TOKEN_KEY,
                            userLoginResponse.token);
                        await prefs.setString(
                            SharedPreferencesKey.USER_NAME_KEY,
                            userLoginResponse.userInfo.name);
                        await prefs.setString(
                            SharedPreferencesKey.USER_EMAIL_KEY,
                            userLoginResponse.userInfo.email);
                        await prefs.setString(
                            SharedPreferencesKey.USER_MOBILE_KEY,
                            userLoginResponse.userInfo.mobile);
                        await prefs.setString(
                            SharedPreferencesKey.USER_AVATAR_KEY,
                            userLoginResponse.userInfo.avatar);
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => UserInfoPage()));
                      } else {
                        Fluttertoast.showToast(
                            msg: "登录失败:${userLoginResponse.msg}");
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
