import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iot_manager_grpc_api/pb/common.pb.dart';
import 'package:iot_manager_grpc_api/pb/userManager.pb.dart';
import 'package:openiothub_api/openiothub_api.dart';

class RegisterPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<RegisterPage> {
//  New
  final TextEditingController _usermobile = TextEditingController(text: "");
  final TextEditingController _userpassword = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("注册"),
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
                TextButton(
                    child: Text('注册'),
                    onPressed: () async {
                      LoginInfo loginInfo = LoginInfo();
                      loginInfo.userMobile = _usermobile.text;
                      loginInfo.password = _userpassword.text;
                      OperationResponse operationResponse =
                          await UserManager.RegisterUserWithUserInfo(loginInfo);
                      if (operationResponse.code == 0) {
                        Fluttertoast.showToast(
                                msg: "注册成功!请使用注册信息登录!${operationResponse.msg}")
                            .then((value) {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }else{

                          }
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "注册失败!请重新注册:${operationResponse.msg}");
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
