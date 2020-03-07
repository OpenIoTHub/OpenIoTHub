import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nat_explorer/constants/Config.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'fileExplorer/services/connection.dart';
import 'fileExplorer/services/connection_methods.dart';

class SSHWebPage extends StatefulWidget {
  SSHWebPage(
      {Key key,
      this.runId,
      this.remoteIp,
      this.remotePort,
      this.userName,
      this.passWord,
      this.localPort})
      : super(key: key);
  String runId;
  String remoteIp;
  int remotePort;
  String userName;
  String passWord;
  int localPort;

  @override
  State<StatefulWidget> createState() => SSHWebPageState();
}

class SSHWebPageState extends State<SSHWebPage> {
  // 标记是否是加载中
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ssh"),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.insert_drive_file,
                color: Colors.white,
              ),
              onPressed: () {
                _pushSSHFileExplorer();
              }),
        ],
      ),
      body: WebView(
        initialUrl:
        "http://${Config.webgRpcIp}:${Config.webStaticPort}/web/open/ssh/index.html",
        javascriptMode : JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          String jsCode =
              "window.localStorage.setItem(\'runId\', \'${widget.runId}\');window.localStorage.setItem(\'remoteIp\', \'${widget.remoteIp}\');window.localStorage.setItem(\'remotePort\', \'${widget.remotePort}\');window.localStorage.setItem(\'userName\', \'${widget.userName}\');window.localStorage.setItem(\'passWord\', \'${widget.passWord}\');location.reload();";
          webViewController.evaluateJavascript(jsCode);
        },
      ),
    );
  }

  void _pushSSHFileExplorer() async {
    // 查看设备下的服务 CommonDeviceServiceTypesList

    Connection _connection = Connection();
    _connection.address = "${Config.webgRpcIp}";
    _connection.port = '${widget.localPort}';
    _connection.username = widget.userName;
    _connection.passwordOrKey = widget.passWord;
    ConnectionMethods.connectClient(
      context,
      address: _connection.address,
      port: int.parse(_connection.port),
      username: _connection.username,
      passwordOrKey: _connection.passwordOrKey,
    ).then((bool connected) {
//      Navigator.popUntil(context, ModalRoute.withName("/"));
      Navigator.of(context).pop();
      if (connected) {
        ConnectionMethods.connect(context, _connection);
      } else {
        print('fail');
      }
    });
  }
}
