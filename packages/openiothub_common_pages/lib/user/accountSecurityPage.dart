import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub_api/openiothub_api.dart';
import 'package:openiothub_common_pages/user/LoginPage.dart';
import 'package:openiothub_common_pages/utils/toast.dart';
import 'package:openiothub_constants/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'package:openiothub_common_pages/openiothub_common_pages.dart';

class AccountSecurityPage extends StatefulWidget {
  @override
  _AccountSecurityPageState createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  StreamSubscription<WechatResp>? _auth;
  List<Widget> _list = <Widget>[];
  String username = "";
  String usermobile = "";
  String useremail = "";

  String bind_wechat_success = "bind wechat success";
  String bind_wechat_failed = "bind wechat failed";
  String get_wechat_login_info_failed = "get wechat login info failed";

  Future<void> _listenAuth(WechatResp resp) async {
    if (resp.errorCode == 0 && resp is WechatAuthResp) {
      OperationResponse operationResponse =
          await UserManager.BindWithWechatCode(resp.code!);
      if (operationResponse.code == 0) {
        show_success(bind_wechat_success, context);
      } else {
        show_failed("${bind_wechat_failed}:${operationResponse.msg}", context);
      }
    } else {
      show_failed("${get_wechat_login_info_failed}:${resp.errorMsg}", context);
    }
  }

  @override
  void initState() {
    if (_auth == null) {
      _auth = WechatKitPlatform.instance.respStream().listen(_listenAuth);
    }
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bind_wechat_success = OpenIoTHubCommonLocalizations.of(context).bind_wechat_success;
    bind_wechat_failed = OpenIoTHubCommonLocalizations.of(context).bind_wechat_failed;
    get_wechat_login_info_failed = OpenIoTHubCommonLocalizations.of(context).get_wechat_login_info_failed;
    return Scaffold(
        appBar: AppBar(
          title: Text(OpenIoTHubCommonLocalizations.of(context).account_and_safety),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              //第一个功能项
              title: Text('${OpenIoTHubCommonLocalizations.of(context).username}：$username'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo(context, OpenIoTHubCommonLocalizations.of(context).username);
              }),
          ListTile(
              //第一个功能项
              title: Text('${OpenIoTHubCommonLocalizations.of(context).user_mobile}：$usermobile'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo(context, OpenIoTHubCommonLocalizations.of(context).user_mobile);
              }),
          ListTile(
              //第一个功能项
              title: Text('${OpenIoTHubCommonLocalizations.of(context).user_email}：$useremail'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo(context, OpenIoTHubCommonLocalizations.of(context).user_email);
              }),
          ListTile(
              //第一个功能项
              title: Text(OpenIoTHubCommonLocalizations.of(context).modify_password),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo(context, OpenIoTHubCommonLocalizations.of(context).password);
              }),
          ListTile(
              //绑定微信
              title: Text(OpenIoTHubCommonLocalizations.of(context).bind_wechat),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                if (await WechatKitPlatform.instance.isInstalled()) {
                  WechatKitPlatform.instance.auth(
                    scope: <String>[WechatScope.kSNSApiUserInfo],
                    state: 'auth',
                  );
                } else {
                  show_failed(OpenIoTHubCommonLocalizations.of(context).no_wechat_installed, context);
                }
              }),
          ListTile(
              //解绑微信
              title: Text(OpenIoTHubCommonLocalizations.of(context).unbind_wechat),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                UserManager.UnbindWechat()
                    .then((OperationResponse operationResponse) {
                  if (operationResponse.code == 0) {
                    show_success(OpenIoTHubCommonLocalizations.of(context).unbind_wechat_success, context);
                  } else {
                    show_failed("${OpenIoTHubCommonLocalizations.of(context).unbind_wechat_failed_reason}${operationResponse.msg}", context);
                  }
                });
              }),
          ListTile(
              //注销账号
              title: Text(
                OpenIoTHubCommonLocalizations.of(context).cancel_account,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                // 删除账号操作，删除账号时需要输入自己的密码进行确认
                _delete_my_account(context);
              }),
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

  Future<void> _modifyInfo(BuildContext context,String type) async {
    TextEditingController _new_value_controller =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text("${OpenIoTHubCommonLocalizations.of(context).modify}：$type"),
                scrollable: true,
                content: SizedBox(
                    height: 100,
                    child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _new_value_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '${OpenIoTHubCommonLocalizations.of(context).please_input_new_value}$type',
                        helperText: OpenIoTHubCommonLocalizations.of(context).new_value,
                      ),
                      obscureText: type == OpenIoTHubCommonLocalizations.of(context).password,
                    ),
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child: Text(OpenIoTHubCommonLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(OpenIoTHubCommonLocalizations.of(context).modify),
                    onPressed: () async {
                      StringValue stringValue = StringValue();
                      stringValue.value = _new_value_controller.text;
                      if (type == OpenIoTHubCommonLocalizations.of(context).username) {
                        OperationResponse operationResponse =
                        await UserManager.UpdateUserNanme(stringValue);
                      } else if (type == OpenIoTHubCommonLocalizations.of(context).user_mobile) {
                        OperationResponse operationResponse =
                        await UserManager.UpdateUserMobile(stringValue);
                      }else if (type == OpenIoTHubCommonLocalizations.of(context).user_email) {
                        OperationResponse operationResponse =
                        await UserManager.UpdateUserEmail(stringValue);
                      }else if (type == OpenIoTHubCommonLocalizations.of(context).password){
                        OperationResponse operationResponse =
                        await UserManager.UpdateUserPassword(stringValue);
                      }
                      Navigator.of(context).pop();
                      _getUserInfo();
                    },
                  )
                ]));
  }

  Future<void> _delete_my_account(BuildContext context) async {
    TextEditingController _new_value_controller =
        TextEditingController.fromValue(TextEditingValue(text: ""));
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(OpenIoTHubCommonLocalizations.of(context).cancel_my_account),
                scrollable: true,
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    Text(
                      OpenIoTHubCommonLocalizations.of(context).cancel_my_account_notify1,
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      OpenIoTHubCommonLocalizations.of(context).operation_cannot_be_restored,
                      style: TextStyle(color: Colors.red),
                    ),
                    TextField(
                      controller: _new_value_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubCommonLocalizations.of(context).please_input_your_password,
                        helperText: OpenIoTHubCommonLocalizations.of(context).current_account_password,
                      ),
                      obscureText: true,
                    ),
                    Text(
                      OpenIoTHubCommonLocalizations.of(context).operation_cannot_be_restored,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child: Text(OpenIoTHubCommonLocalizations.of(context).confirm_cancel_account, style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      LoginInfo login_info = LoginInfo();
                      login_info.password = _new_value_controller.text;
                      OperationResponse operationResponse =
                          await UserManager.DeleteMyAccount(login_info);
                      if (operationResponse.code == 0) {
                        //删除账号成功
                        show_success(OpenIoTHubCommonLocalizations.of(context).cancel_account_success, context);
                        Navigator.of(context).pop();
                      } else {
                        show_failed("${OpenIoTHubCommonLocalizations.of(context).cancel_account_failed}:${operationResponse.msg}", context);
                      }
                    },
                  ),
                  TextButton(
                    child: Text(
                      OpenIoTHubCommonLocalizations.of(context).cancel,
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }
}
