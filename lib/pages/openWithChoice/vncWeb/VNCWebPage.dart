import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:openiothub/constants/Config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNCWebPage extends StatefulWidget {
  VNCWebPage({Key key, this.runId, this.remoteIp, this.remotePort})
      : super(key: key);
  String runId;
  String remoteIp;
  int remotePort;

  @override
  State<StatefulWidget> createState() => VNCWebPageState();
}

class VNCWebPageState extends State<VNCWebPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: WebView(
        initialUrl:
        "http://${Config.webStaticIp}:${Config.webStaticPort}/web/open/vnc/index.html?host=${Config.webgRpcIp}&port=${Config.webRestfulPort}&path=proxy%2fws%2fconnect%2fwebsockify%3frunId%3d${widget.runId}%26remoteIp%3d${widget.remoteIp}%26remotePort%3d${widget.remotePort}&encrypt=0",
        javascriptMode : JavascriptMode.unrestricted
      ),
    );
  }
}
