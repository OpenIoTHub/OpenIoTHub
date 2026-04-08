//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:openiothub/pages/common/web/web.dart';

import 'package:openiothub/models/port_service_info.dart';

class WebPage extends StatefulWidget {
  const WebPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.web";
  final PortServiceInfo device;

  @override
  State<WebPage> createState() => WebPageState();
}

class WebPageState extends State<WebPage> {
  @override
  Widget build(BuildContext context) {
    var url = 'http://${widget.device.addr}:${widget.device.port}';
    // TODO 更换web插件
//    解决退出没有断连的问题
    return WebScreen(startUrl: url,);
  }

  @override
  void initState() {
    super.initState();
    // if (Platform.isIOS) {
    //   Navigator.of(context).pop();
    //   _launchUrl('http://${widget.device.addr}:${widget.device.port}');
    // } else {
    //   _launchUrl('http://${widget.device.addr}:${widget.device.port}');
    // }
    var url = 'http://${widget.device.addr}:${widget.device.port}';
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _launchUrl(url);
      return;
    }
  }

  _launchUrl(String url) async {
//    await intent.launch();
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      debugPrint('Could not launch $url');
    }
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // 直接使用系统浏览器就不进入本页
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }
}
