import 'package:flutter/material.dart';
import 'package:nat_explorer/model/portService.dart';

class InfoPage extends StatelessWidget {
  InfoPage({Key key, this.device}) : super(key: key);
  PortService device;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //设备信息
    final List _result = [];
    _result.add("设备名称:${device.info["name"]}");
    _result.add("设备型号:${device.info["model"].replaceAll("#",".")}");
    _result.add("物理地址:${device.info["mac"]}");
    _result.add("id:${device.info["id"]}");
    _result.add("固件作者:${device.info["author"]}");
    _result.add("邮件:${device.info["email"]}");
    _result.add("主页:${device.info["home-page"]}");
    _result.add("固件程序:${device.info["firmware-respository"]}");
    _result.add("固件版本:${device.info["firmware-version"]}");
    _result.add("本网设备:${device.noProxy ? "是" : "不是"}");
    _result.add("设备地址:http://${device.ip}:${device.port}");

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
