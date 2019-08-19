import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:android_intent/android_intent.dart';
import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/pages/plugin/subPluginType/pluginModel.dart';

class EspPluginDemoPage extends StatefulWidget {
  EspPluginDemoPage({Key key, this.plugin}) : super(key: key);

  final Plugin plugin;

  @override
  _EspPluginDemoPageState createState() => _EspPluginDemoPageState();
}

class _EspPluginDemoPageState extends State<EspPluginDemoPage> {
  static const Color onColor = Colors.green;
  static const Color offColor = Colors.red;
  bool ledBottonStatus = false;

  @override
  void initState() {
    super.initState();
    _getCurrentStatus();
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开关控制"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                _setting();
              }),
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                _info();
              }),
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  color: ledBottonStatus ? onColor : offColor,
                  iconSize: 100.0,
                  onPressed: () {
                    _changeSwitchStatus();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ledBottonStatus ? Text("已经开启") : Text("已经关闭"),
              ],
            )
          ]),
    );
  }

  _getCurrentStatus() async {
    String url = "http://${Config.webgRpcIp}:${widget.plugin.portConfig.localProt}/status";
    http.Response response;
    try{
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    }catch(e){
      print(e.toString());
      return;
    }
    if(response.statusCode == 200 && jsonDecode(response.body)["led1"]==1){
      setState(() {
        ledBottonStatus = true;
      });
    }else{
      setState(() {
        ledBottonStatus = false;
      });
    }
  }

  _setting() async {
    // TODO 设备设置
    TextEditingController _name_controller =
    TextEditingController.fromValue(TextEditingValue(text: widget.plugin.info.bodyBytes["name"]));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text("设置名称："),
            content: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _name_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '名称',
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("修改"),
                onPressed: () async {
                  try{
                    String url = "http://${Config.webgRpcIp}:${widget.plugin.portConfig.localProt}/rename?name=${_name_controller.text}";
                    http.get(url).timeout(const Duration(seconds: 2));
                  }catch(e){
                    print(e.toString());
                    return;
                  }
                  Navigator.of(context).pop();
                },
              )
            ]));
  }

  _info() async {
    // TODO 设备信息
    final List _result = [];
    _result.add("设备名称:${widget.plugin.info["name"]}");
    _result.add("设备型号:${widget.plugin.info["model"]}");
    _result.add("支持的界面:${widget.plugin.info["ui-support"]}");
    _result.add("首选界面:${widget.plugin.info["ui-first"]}");
    _result.add("固件作者:${widget.plugin.info["author"]}");
    _result.add("邮件:${widget.plugin.info["email"]}");
    _result.add("主页:${widget.plugin.info["home-page"]}");
    _result.add("固件程序:${widget.plugin.info["firmware-respository"]}");
    _result.add("固件版本:${widget.plugin.info["firmware-version"]}");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
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
        },
      ),
    );
  }

  _changeSwitchStatus() async {
    String url;
    if (ledBottonStatus) {
      url = "http://${Config.webgRpcIp}:${widget.plugin.portConfig.localProt}/led?pin=OFF1";
    }else {
      url = "http://${Config.webgRpcIp}:${widget.plugin.portConfig.localProt}/led?pin=ON1";
    }
    http.Response response;
    try{
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    }catch(e){
      print(e.toString());
      return;
    }
    _getCurrentStatus();
  }

  _launchURL(String url) async {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    await intent.launch();
  }
}
