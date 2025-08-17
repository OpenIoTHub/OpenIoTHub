//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:openiothub_common_pages/web/web.dart';

import 'package:openiothub_plugin/openiothub_plugin.dart';

import '../../../models/PortServiceInfo.dart';

class WebPage extends StatefulWidget {
  WebPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.web";
  final PortServiceInfo device;

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  Widget build(BuildContext context) {
    var _url = 'http://${widget.device.addr}:${widget.device.port}';
    // TODO 更换web插件
//    解决退出没有断连的问题
    return WebScreen(startUrl: _url,);
  }

  _info() async {
    Navigator.of(context).pop();
    // TODO 设备信息
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // if (Platform.isIOS) {
    //   Navigator.of(context).pop();
    //   _launchURL('http://${widget.device.addr}:${widget.device.port}');
    // } else {
    //   _launchURL('http://${widget.device.addr}:${widget.device.port}');
    // }
    var _url = 'http://${widget.device.addr}:${widget.device.port}';
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _launchURL(_url);
      return;
    }
  }

  _launchURL(String url) async {
//    await intent.launch();
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      print('Could not launch $url');
    }
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // 直接使用系统浏览器就不进入本页
      Navigator.of(context).pop();
    }
  }
}
