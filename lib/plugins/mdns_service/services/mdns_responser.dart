//这个模型是用来使用WebDAV的文件服务器来操作文件的
import 'package:flutter/material.dart';

import 'package:openiothub/models/port_service_info.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';
import 'package:openiothub/widgets/mdns/info.dart';

//手动注册一些端口到mdns的声明，用于接入一些传统的设备或者服务或者帮助一些不方便注册mdns的设备或服务注册
//需要选择模型和输入相关配置参数
class MDNSResponserPage extends StatefulWidget {
  const MDNSResponserPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.services.mdnsResponser";
  final PortServiceInfo device;

  @override
  State<MDNSResponserPage> createState() => MDNSResponserPageState();
}

class MDNSResponserPageState extends State<MDNSResponserPage> {
  List<String> pathHistory = ["/"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pathHistory.last),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.green,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: openIoTHubDesktopConstrainedBody(
        child: const SizedBox.expand(),
      ),
    );
  }

  _info() async {
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
}
