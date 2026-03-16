import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/common_pages/user/login_page.dart';
import 'package:openiothub/common_pages/utils/toast.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'package:openiothub/common_pages/openiothub_common_pages.dart';

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

  String bindWechatSuccess = "bind wechat success";
  String bindWechatFailed = "bind wechat failed";
  String getWechatLoginInfoFailed = "get wechat login info failed";

  Future<void> _listenAuth(WechatResp resp) async {
    if (resp.errorCode == 0 && resp is WechatAuthResp) {
      OperationResponse operationResponse =
          await UserManager.bindWithWechatCode(resp.code!);
      if (operationResponse.code == 0) {
        showSuccess(bindWechatSuccess, context);
      } else {
        showFailed("${bindWechatFailed}:${operationResponse.msg}", context);
      }
    } else {
      showFailed("${getWechatLoginInfoFailed}:${resp.errorMsg}", context);
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
    bindWechatSuccess = OpenIoTHubCommonLocalizations.of(context).bind_wechat_success;
    bindWechatFailed = OpenIoTHubCommonLocalizations.of(context).bind_wechat_failed;
    getWechatLoginInfoFailed = OpenIoTHubCommonLocalizations.of(context).get_wechat_login_info_failed;
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
                  showFailed(OpenIoTHubCommonLocalizations.of(context).no_wechat_installed, context);
                }
              }),
          ListTile(
              //解绑微信
              title: Text(OpenIoTHubCommonLocalizations.of(context).unbind_wechat),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                UserManager.unbindWechat()
                    .then((OperationResponse operationResponse) {
                  if (operationResponse.code == 0) {
                    showSuccess(OpenIoTHubCommonLocalizations.of(context).unbind_wechat_success, context);
                  } else {
                    showFailed("${OpenIoTHubCommonLocalizations.of(context).unbind_wechat_failed_reason}${operationResponse.msg}", context);
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
                _deleteMyAccount(context);
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

  Future<void> _modifyInfo(BuildContext context,String type) async {
    TextEditingController _newValueController =
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
                      controller: _newValueController,
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
                      stringValue.value = _newValueController.text;
                      if (type == OpenIoTHubCommonLocalizations.of(context).username) {
                        OperationResponse operationResponse =
                        await UserManager.updateUserName(stringValue);
                      } else if (type == OpenIoTHubCommonLocalizations.of(context).user_mobile) {
                        OperationResponse operationResponse =
                        await UserManager.updateUserMobile(stringValue);
                      }else if (type == OpenIoTHubCommonLocalizations.of(context).user_email) {
                        OperationResponse operationResponse =
                        await UserManager.updateUserEmail(stringValue);
                      }else if (type == OpenIoTHubCommonLocalizations.of(context).password){
                        OperationResponse operationResponse =
                        await UserManager.updateUserPassword(stringValue);
                      }
                      Navigator.of(context).pop();
                      _getUserInfo();
                    },
                  )
                ]));
  }

  Future<void> _deleteMyAccount(BuildContext context) async {
    TextEditingController _newValueController =
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
                      controller: _newValueController,
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
                      LoginInfo loginInfo = LoginInfo();
                      loginInfo.password = _newValueController.text;
                      OperationResponse operationResponse =
                          await UserManager.deleteMyAccount(loginInfo);
                      if (operationResponse.code == 0) {
                        //删除账号成功
                        showSuccess(OpenIoTHubCommonLocalizations.of(context).cancel_account_success, context);
                        Navigator.of(context).pop();
                      } else {
                        showFailed("${OpenIoTHubCommonLocalizations.of(context).cancel_account_failed}:${operationResponse.msg}", context);
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
