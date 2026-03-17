import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/network/openiothub_api.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/common_pages/utils/toast.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/userManager.pb.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';


class RegisterPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<RegisterPage> {
  // 是否已经同意隐私政策
  bool _isChecked = false;
  bool _registerDisabled = false;

//  New
  final TextEditingController _usermobile = TextEditingController(text: "");
  final TextEditingController _userpassword = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(OpenIoTHubLocalizations.of(context).register),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TDInput(
                  controller: _usermobile,
                  backgroundColor: Colors.white,
                  leftLabel:
                      OpenIoTHubLocalizations.of(context).mobile_number,
                  hintText: OpenIoTHubLocalizations.of(context)
                      .please_input_mobile,
                  onChanged: (String v) {},
                ),
                TDInput(
                  controller: _userpassword,
                  backgroundColor: Colors.white,
                  leftLabel: OpenIoTHubLocalizations.of(context).password,
                  hintText: OpenIoTHubLocalizations.of(context)
                      .please_input_password,
                  obscureText: true,
                  onChanged: (String v) {},
                ),
                TDButton(
                    icon: TDIcons.login,
                    text: OpenIoTHubLocalizations.of(context).register,
                    size: TDButtonSize.large,
                    type: TDButtonType.outline,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.primary,
                    disabled: _registerDisabled,
                    onTap: () async {
                      _register();
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue!;
                        });
                      },
                      activeColor: Colors.green, // 选中时的颜色
                      checkColor: Colors.white, // 选中标记的颜色
                    ),
                    Text(OpenIoTHubLocalizations.of(context).agree),
                    TextButton(
                        child: Text(
                          OpenIoTHubLocalizations.of(context)
                              .privacy_policy,
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
                          goToUrl(
                              context,
                              "https://docs.iothub.cloud/privacyPolicy/index.html",
                              OpenIoTHubLocalizations.of(context)
                                  .privacy_policy);
                        }),
                    TextButton(
                        child: Text(
                          OpenIoTHubLocalizations.of(context)
                              .feedback_channels,
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FeedbackPage(
                                    key: UniqueKey(),
                                  )));
                        }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _register() async {
    // TODO 防止重复注册
    setState(() {
      _registerDisabled = true;
    });
    Future.delayed(Duration(seconds: 5), (){
      setState(() {
        _registerDisabled = false;
      });
    });
    if (!_isChecked) {
      showFailed(
          "${OpenIoTHubLocalizations.of(context).agree_to_the_user_agreement1}☑️${OpenIoTHubLocalizations.of(context).agree_to_the_user_agreement2}",
          context);
      return;
    }
    if (_usermobile.text.isEmpty || _userpassword.text.isEmpty) {
      showFailed(
          OpenIoTHubLocalizations.of(context)
              .common_username_and_password_cant_be_empty,
          context);
      return;
    }
    LoginInfo loginInfo = LoginInfo();
    loginInfo.userMobile = _usermobile.text;
    loginInfo.password = _userpassword.text;
    OperationResponse operationResponse =
        await UserManager.registerUserWithUserInfo(loginInfo);
    if (operationResponse.code == 0) {
      setState(() {
        _registerDisabled = false;
      });
      showSuccess(
          "${OpenIoTHubLocalizations.of(context).register_success}${operationResponse.msg}",
          context);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {}
    } else {
      showFailed(
          "${OpenIoTHubLocalizations.of(context).register_failed}:${operationResponse.msg}",
          context);
    }
  }
}
