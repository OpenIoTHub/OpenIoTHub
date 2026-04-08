import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'package:openiothub/pages/common/openiothub_common_pages.dart';

class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({super.key});

  @override
  State<AccountSecurityPage> createState() => AccountSecurityPageState();
}

class AccountSecurityPageState extends State<AccountSecurityPage> {
  StreamSubscription<WechatResp>? _auth;
  String username = "";
  String usermobile = "";
  String useremail = "";

  String bindWechatSuccess = "bind wechat success";
  String bindWechatFailed = "bind wechat failed";
  String getWechatLoginInfoFailed = "get wechat login info failed";

  Future<void> _listenAuth(WechatResp resp) async {
    final ctx = context;
    if (resp.errorCode == 0 && resp is WechatAuthResp) {
      OperationResponse operationResponse =
          await UserManager.bindWithWechatCode(resp.code!);
      if (!ctx.mounted) return;
      if (operationResponse.code == 0) {
        showSuccess(bindWechatSuccess, ctx);
      } else {
        showFailed("$bindWechatFailed:${operationResponse.msg}", ctx);
      }
    } else {
      if (!ctx.mounted) return;
      showFailed("$getWechatLoginInfoFailed:${resp.errorMsg}", ctx);
    }
  }

  @override
  void initState() {
    _auth ??= WechatKitPlatform.instance.respStream().listen(_listenAuth);
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bindWechatSuccess = OpenIoTHubLocalizations.of(context).bind_wechat_success;
    bindWechatFailed = OpenIoTHubLocalizations.of(context).bind_wechat_failed;
    getWechatLoginInfoFailed = OpenIoTHubLocalizations.of(context).get_wechat_login_info_failed;
    return Scaffold(
        appBar: AppBar(
          title: Text(OpenIoTHubLocalizations.of(context).account_and_safety),
        ),
        body: ListView(children: <Widget>[
          ListTile(
              //第一个功能项
              title: Text('${OpenIoTHubLocalizations.of(context).username}：$username'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo(context, OpenIoTHubLocalizations.of(context).username);
              }),
          ListTile(
              //第一个功能项
              title: Text('${OpenIoTHubLocalizations.of(context).user_mobile}：$usermobile'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo(context, OpenIoTHubLocalizations.of(context).user_mobile);
              }),
          ListTile(
              //第一个功能项
              title: Text('${OpenIoTHubLocalizations.of(context).user_email}：$useremail'),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo(context, OpenIoTHubLocalizations.of(context).user_email);
              }),
          ListTile(
              //第一个功能项
              title: Text(OpenIoTHubLocalizations.of(context).modify_password),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                _modifyInfo(context, OpenIoTHubLocalizations.of(context).password);
              }),
          ListTile(
              //绑定微信
              title: Text(OpenIoTHubLocalizations.of(context).bind_wechat),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                final ctx = context;
                final l10n = OpenIoTHubLocalizations.of(ctx);
                if (await WechatKitPlatform.instance.isInstalled()) {
                  WechatKitPlatform.instance.auth(
                    scope: <String>[WechatScope.kSNSApiUserInfo],
                    state: 'auth',
                  );
                } else {
                  if (!ctx.mounted) return;
                  showFailed(l10n.no_wechat_installed, ctx);
                }
              }),
          ListTile(
              //解绑微信
              title: Text(OpenIoTHubLocalizations.of(context).unbind_wechat),
              trailing: Icon(Icons.arrow_right),
              onTap: () async {
                final ctx = context;
                final l10n = OpenIoTHubLocalizations.of(ctx);
                final operationResponse = await UserManager.unbindWechat();
                if (!ctx.mounted) return;
                if (operationResponse.code == 0) {
                  showSuccess(l10n.unbind_wechat_success, ctx);
                } else {
                  showFailed("${l10n.unbind_wechat_failed_reason}${operationResponse.msg}", ctx);
                }
              }),
          ListTile(
              //注销账号
              title: Text(
                OpenIoTHubLocalizations.of(context).cancel_account,
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
    final ctx = context;
    bool b = await userSignedIn();
    if (!b) {
      if (!ctx.mounted) return;
      Navigator.of(ctx)
          .push(MaterialPageRoute(builder: (context) => const LoginPage()));
    }
    //从网络同步一遍到本地
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfo userInfo = await UserManager.getUserInfo();
    if (!ctx.mounted) return;
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

  Future<void> _modifyInfo(BuildContext context, String type) async {
    final newValueController =
        TextEditingController.fromValue(const TextEditingValue(text: ''));
    showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
                title: Text("${OpenIoTHubLocalizations.of(context).modify}：$type"),
                scrollable: true,
                content: SizedBox(
                    height: 100,
                    child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: newValueController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '${OpenIoTHubLocalizations.of(context).please_input_new_value}$type',
                        helperText: OpenIoTHubLocalizations.of(context).new_value,
                      ),
                      obscureText: type == OpenIoTHubLocalizations.of(context).password,
                    ),
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).modify),
                    onPressed: () async {
                      final ctx = context;
                      final l10n = OpenIoTHubLocalizations.of(ctx);
                      StringValue stringValue = StringValue();
                      stringValue.value = newValueController.text;
                      if (type == l10n.username) {
                        await UserManager.updateUserName(stringValue);
                      } else if (type == l10n.user_mobile) {
                        await UserManager.updateUserMobile(stringValue);
                      } else if (type == l10n.user_email) {
                        await UserManager.updateUserEmail(stringValue);
                      } else if (type == l10n.password) {
                        await UserManager.updateUserPassword(stringValue);
                      }
                      if (!dialogContext.mounted) return;
                      Navigator.of(dialogContext).pop();
                      if (!ctx.mounted) return;
                      _getUserInfo();
                    },
                  )
                ]));
  }

  Future<void> _deleteMyAccount(BuildContext context) async {
    final passwordController =
        TextEditingController.fromValue(const TextEditingValue(text: ''));
    showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
                title: Text(OpenIoTHubLocalizations.of(context).cancel_my_account),
                scrollable: true,
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    Text(
                      OpenIoTHubLocalizations.of(context).cancel_my_account_notify1,
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      OpenIoTHubLocalizations.of(context).operation_cannot_be_restored,
                      style: TextStyle(color: Colors.red),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: OpenIoTHubLocalizations.of(context).please_input_your_password,
                        helperText: OpenIoTHubLocalizations.of(context).current_account_password,
                      ),
                      obscureText: true,
                    ),
                    Text(
                      OpenIoTHubLocalizations.of(context).operation_cannot_be_restored,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child: Text(OpenIoTHubLocalizations.of(context).confirm_cancel_account, style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      final ctx = context;
                      final l10n = OpenIoTHubLocalizations.of(ctx);
                      LoginInfo loginInfo = LoginInfo();
                      loginInfo.password = passwordController.text;
                      OperationResponse operationResponse =
                          await UserManager.deleteMyAccount(loginInfo);
                      if (!ctx.mounted) return;
                      if (operationResponse.code == 0) {
                        //删除账号成功
                        showSuccess(l10n.cancel_account_success, ctx);
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      } else {
                        showFailed("${l10n.cancel_account_failed}:${operationResponse.msg}", ctx);
                      }
                    },
                  ),
                  TextButton(
                    child: Text(
                      OpenIoTHubLocalizations.of(context).cancel,
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ]));
  }
}
