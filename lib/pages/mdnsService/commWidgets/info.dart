import 'package:flutter/material.dart';
import 'package:openiothub/model/portService.dart';

class InfoPage extends StatelessWidget {
  InfoPage({Key key, this.portService}) : super(key: key);
  PortService portService;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //设备信息
    final List _result = [];
    _result.add("设备名称:${portService.info["name"]}");
    _result.add("设备型号:${portService.info["model"].replaceAll("#",".")}");
    _result.add("物理地址:${portService.info["mac"]}");
    _result.add("id:${portService.info["id"]}");
    _result.add("固件作者:${portService.info["author"]}");
    _result.add("邮件:${portService.info["email"]}");
    _result.add("主页:${portService.info["home-page"]}");
    _result.add("固件程序:${portService.info["firmware-respository"]}");
    _result.add("固件版本:${portService.info["firmware-version"]}");
    _result.add("本网设备:${portService.isLocal ? "是" : "不是"}");
    _result.add("设备地址:http://${portService.ip}:${portService.port}");

    final tiles = _result.map(
      (pair) {
        return ListTile(
          title: Text(
            pair,
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('设备信息'),
      ),
      body: ListView(children: divided),
    );
  }
}
