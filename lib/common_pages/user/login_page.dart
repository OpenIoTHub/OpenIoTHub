import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/app/providers/auth_provider.dart';
import 'package:openiothub/router/core/app_routes.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // 是否已经同意隐私政策
  bool _isChecked = false;
  bool _loginDisabled = false;
  StreamSubscription<WechatResp>? _auth;
  List<Widget> _list = <Widget>[];

  //微信扫码登录随机id
  String? loginFlag;
  late Timer _timer;

  String wechatLoginFailed = "wechat login failed";

  //  New
  final TextEditingController _usermobile = TextEditingController(text: "");
  final TextEditingController _userpassword = TextEditingController(text: "");

  Future<void> _listenAuth(WechatResp resp) async {
    if (resp.errorCode == 0 && resp is WechatAuthResp) {
      UserLoginResponse userLoginResponse =
          await UserManager.loginWithWechatCode(resp.code!);
      await _handleLoginResp(userLoginResponse);
    } else {
      showFailed("$wechatLoginFailed:${resp.errorMsg}", context);
    }
  }

  @override
  void initState() {
    _auth ??= WechatKitPlatform.instance.respStream().listen(_listenAuth);
    super.initState();
    _initList().then((value) => _checkWechat());
    _initTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    wechatLoginFailed = OpenIoTHubLocalizations.of(context).wechat_login_failed;
    return Scaffold(
      appBar: AppBar(
        title: Text(OpenIoTHubLocalizations.of(context).login),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: OpenIoTHubLocalizations.of(context).language,
            onPressed: () => context.push(AppRoutes.languagePicker),
          ),
        ],
      ),
      body: Center(
        child: openIoTHubDesktopConstrainedBody(
          maxWidth: 440,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _list,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initList() async {
    setState(() {
      _list = <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // 设置顶部距离
          child: TDInput(
            controller: _usermobile,
            backgroundColor: Colors.white,
            leftLabel: OpenIoTHubLocalizations.of(context).user_mobile,
            hintText: OpenIoTHubLocalizations.of(context).please_input_mobile,
            onChanged: (String v) {},
          ),
        ),
        TDInput(
          controller: _userpassword,
          backgroundColor: Colors.white,
          leftLabel: OpenIoTHubLocalizations.of(context).password,
          hintText: OpenIoTHubLocalizations.of(context).please_input_password,
          obscureText: true,
          onChanged: (String v) {},
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // 设置顶部距离
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TDButton(
                icon: TDIcons.login,
                text: OpenIoTHubLocalizations.of(context).login,
                size: TDButtonSize.medium,
                type: TDButtonType.outline,
                shape: TDButtonShape.rectangle,
                theme: TDButtonTheme.primary,
                disabled: _loginDisabled,
                onTap: () async {
                  setState(() {
                    _loginDisabled = true;
                  });
                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {
                      _loginDisabled = false;
                    });
                  });
                  // 只有同意隐私政策才可以进行下一步
                  if (!_isChecked) {
                    showFailed(
                      "${OpenIoTHubLocalizations.of(context).agree_to_the_user_agreement1}☑️${OpenIoTHubLocalizations.of(context).agree_to_the_user_agreement2}",
                      context,
                    );
                    return;
                  }
                  if (_usermobile.text.isEmpty || _userpassword.text.isEmpty) {
                    showFailed(
                      OpenIoTHubLocalizations.of(
                        context,
                      ).common_username_and_password_cant_be_empty,
                      context,
                    );
                    return;
                  }
                  LoginInfo loginInfo = LoginInfo();
                  loginInfo.userMobile = _usermobile.text;
                  loginInfo.password = _userpassword.text;
                  UserLoginResponse userLoginResponse =
                      await UserManager.loginWithUserLoginInfo(loginInfo);
                  if (!mounted) return;
                  setState(() {
                    _loginDisabled = false;
                  });
                  await _handleLoginResp(userLoginResponse);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0), // 设置顶部距离
                child: TDButton(
                  icon: TDIcons.user,
                  text: OpenIoTHubLocalizations.of(context).user_registration,
                  size: TDButtonSize.medium,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // 设置顶部距离
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isChecked = newValue!;
                    _initList().then((value) => _checkWechat());
                  });
                },
                activeColor: Colors.green, // 选中时的颜色
                checkColor: Colors.white, // 选中标记的颜色
              ),
              Text(OpenIoTHubLocalizations.of(context).agree),
              TextButton(
                // TODO 勾选才可以下一步
                child: Text(
                  OpenIoTHubLocalizations.of(context).common_privacy_policy,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  goToUrl(
                    context,
                    "https://docs.iothub.cloud/privacyPolicy/index.html",
                    OpenIoTHubLocalizations.of(context).privacy_policy,
                  );
                },
              ),
              TextButton(
                child: Text(
                  OpenIoTHubLocalizations.of(context).common_feedback_channels,
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FeedbackPage(key: UniqueKey()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ];
    });
  }

  Future<void> _checkWechat() async {
    if (Platform.isIOS || Platform.isMacOS) {
      // TODO iOS支持第三方登录就得支持苹果登录
      return;
    }
    setState(() {
      // TODO 在pc上使用二维码扫码登录，可以使用网页一套Api
      _list.add(
        IconButton(
          icon: Icon(TDIcons.logo_wechat_stroke, color: Colors.green, size: 45),
          style: ButtonStyle(
            fixedSize: const WidgetStatePropertyAll<Size>(Size(70, 70)),
          ),
          onPressed: () async {
            _wechatLogin();
          },
        ),
      );
    });
  }

  Future<void> _handleLoginResp(UserLoginResponse userLoginResponse) async {
    if (userLoginResponse.code == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        SharedPreferencesKey.userTokenKey,
        userLoginResponse.token,
      );
      await prefs.setString(
        SharedPreferencesKey.userNameKey,
        userLoginResponse.userInfo.name,
      );
      await prefs.setString(
        SharedPreferencesKey.userEmailKey,
        userLoginResponse.userInfo.email,
      );
      await prefs.setString(
        SharedPreferencesKey.userMobileKey,
        userLoginResponse.userInfo.mobile,
      );
      await prefs.setString(
        SharedPreferencesKey.userAvatarKey,
        userLoginResponse.userInfo.avatar,
      );

      Future.delayed(Duration(milliseconds: 500), () {
        UtilApi.syncConfigWithToken();
      });

      if (!mounted) return;
      await context.read<AuthProvider>().loadCurrentToken();
      if (!mounted) return;
      context.go(AppRoutes.home);
    } else {
      final l10n = OpenIoTHubLocalizations.of(context);
      showFailed(
        "${l10n.common_login_failed}:code:${userLoginResponse.code},message:${userLoginResponse.msg}",
        context,
      );
    }
  }

  Future<void> _initTimer() async {
    // 获取扫码登录结果
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (loginFlag != null && loginFlag!.isNotEmpty) {
        final ctx = context;
        String loginRetUrl =
            "https://${Config.iotManagerHttpIp}/wxLogin/loginOrCreate?clientType=app&loginFlag=$loginFlag";
        final dio = Dio();
        final response = await dio.get(loginRetUrl);
        if (!ctx.mounted) return;
        final l10n = OpenIoTHubLocalizations.of(ctx);
        if (response.data["code"] == 0 &&
            (response.data["data"] as Map<String, dynamic>).containsKey(
              "token",
            ) &&
            response.data["data"]["token"] != null &&
            response.data["data"]["token"] != "") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            SharedPreferencesKey.userTokenKey,
            response.data["data"]["token"],
          );
          await prefs.setString(
            SharedPreferencesKey.userNameKey,
            response.data["data"]["user"]["nickName"],
          );
          await prefs.setString(
            SharedPreferencesKey.userEmailKey,
            response.data["data"]["user"]["email"],
          );
          await prefs.setString(
            SharedPreferencesKey.userMobileKey,
            response.data["data"]["user"]["phone"],
          );
          await prefs.setString(
            SharedPreferencesKey.userAvatarKey,
            response.data["data"]["user"]["headerImg"],
          );

          if (!ctx.mounted) return;
          Future.delayed(Duration(milliseconds: 500), () {
            UtilApi.syncConfigWithToken();
          });
          timer.cancel();
          if (!ctx.mounted) return;
          await ctx.read<AuthProvider>().loadCurrentToken();
          if (!ctx.mounted) return;
          ctx.go(AppRoutes.home);
        } else if ((response.data["data"] as Map<String, dynamic>).containsKey(
              "scan",
            ) &&
            (response.data["data"] as Map<String, dynamic>)["scan"] == true) {
          showSuccess(l10n.login_after_wechat_bind, ctx);
        } else if ((response.data["data"] as Map<String, dynamic>).containsKey(
              "scan",
            ) &&
            (response.data["data"] as Map<String, dynamic>)["scan"] == false) {
          // showToast("请扫码！");
        } else {
          showFailed(
            "${l10n.wechat_fast_login_failed}：${response.data["msg"]}",
            ctx,
          );
        }
      }
    });
  }

  _wechatLogin() async {
    // 只有同意隐私政策才可以进行下一步
    if (!_isChecked) {
      showFailed(
        "${OpenIoTHubLocalizations.of(context).agree_to_the_user_agreement1}☑️${OpenIoTHubLocalizations.of(context).agree_to_the_user_agreement2}",
        context,
      );
      return;
    }
    final ctx = context;
    // 判断是否安装了微信，安装了微信则打开微信进行登录，否则显示二维码由手机扫描登录
    bool wechatInstalled = false;
    try {
      wechatInstalled = await WechatKitPlatform.instance.isInstalled();
    } on Exception {
      wechatInstalled = false;
    }
    if (!ctx.mounted) return;
    if (wechatInstalled) {
      WechatKitPlatform.instance.auth(
        scope: <String>[WechatScope.kSNSApiUserInfo],
        state: 'auth',
      );
    } else if (!Platform.isIOS) {
      // 由于 iOS 审核，可能需要在 iOS 上屏蔽二维码登录
      // 参考: pub.dev/packages/sign_in_with_apple
      // 显示二维码扫描登录
      final l10n = OpenIoTHubLocalizations.of(ctx);
      loginFlag = generateRandomString(12);
      String qrUrl = await getPicUrl(loginFlag!);
      if (!ctx.mounted) return;
      if (qrUrl == "") {
        showFailed(l10n.get_wechat_qr_code_failed, ctx);
        return;
      }
      // 循环获取登录结果
      showDialog(
        context: ctx,
        builder:
            (_) => AlertDialog(
              title: Text(l10n.wechat_scan_qr_code_to_login),
              content: SizedBox.expand(child: Image.network(qrUrl)),
              actions: <Widget>[
                // 分享网关:二维码图片、小程序链接、网页
                TDButton(
                  icon: TDIcons.fullscreen_exit,
                  text: l10n.exit,
                  size: TDButtonSize.small,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.primary,
                  onTap: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
      ).then((_) => {loginFlag = null});
    }
  }
}

String generateRandomString(int length) {
  if (length == 0) {
    length = 12;
  }
  const String charset =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  final Random random = Random();
  String result = '';
  for (var i = 0; i < length; i++) {
    result += charset[random.nextInt(charset.length)];
  }
  return result;
}

Future<String> getPicUrl(String loginFlag) async {
  final dio = Dio();
  late String url;
  String reqUrl =
      "https://${Config.iotManagerHttpIp}/wxLogin/getLoginPic?loginFlag=$loginFlag";
  final response = await dio.get(reqUrl);
  if (response.data["code"] == 0) {
    String ticket = response.data["data"]["ticket"];
    url = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=$ticket";
    return url;
  } else {
    return "";
  }
}
