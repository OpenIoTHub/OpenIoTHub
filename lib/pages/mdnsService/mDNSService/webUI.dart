//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/model/custom_theme.dart';
import 'package:provider/provider.dart';
import '../../../model/portService.dart';
import '../commWidgets/info.dart';
import 'package:webdav/webdav.dart';

class WebPage extends StatefulWidget {
  WebPage({Key key, this.serviceInfo}) : super(key: key);

  static final String modelName = "com.iotserv.services.web";
  final PortService serviceInfo;

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  List<String> pathHistory = ["/"];
  List<FileInfo> listFile = [];

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.serviceInfo.baseUrl,
      appBar: new AppBar(title: new Text("浏览器"), actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              _info();
            }),
        IconButton(
            icon: Icon(
              Icons.open_in_browser,
              color: Colors.white,
            ),
            onPressed: () {
              _launchURL(widget.serviceInfo.baseUrl);
            })
      ]),
      withZoom: true,
      resizeToAvoidBottomInset:true,
    );

  }

  _info() async {
    await Navigator.of(context).pop();
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            device: widget.serviceInfo,
          );
        },
      ),
    );
  }

  _launchURL(String url) async {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    await intent.launch();
  }

}
