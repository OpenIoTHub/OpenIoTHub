//PhicommDC1Plugin:https://github.com/iotdevice/phicomm_dc1
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nat_explorer/constants/Config.dart';
import 'package:nat_explorer/pages/device/iotDevice/iotDeviceModel.dart';

class PhicommDC1PluginPage extends StatefulWidget {
  PhicommDC1PluginPage({Key key, this.device}) : super(key: key);

  final IoTDevice device;

  @override
  _PhicommDC1PluginPageState createState() => _PhicommDC1PluginPageState();
}

class _PhicommDC1PluginPageState extends State<PhicommDC1PluginPage> {
  static const Color onColor = Colors.green;
  static const Color offColor = Colors.red;

  static const String logLed = "logLed";
  static const String wifiLed = "wifiLed";
  static const String primarySwitch = "primarySwitch";
//  bool _logLedStatus = true;
//  bool _wifiLedStatus = true;
//  bool _primarySwitchStatus = true;
  Map<String, bool> _status = Map.from({
    logLed:true,
    wifiLed:true,
    primarySwitch:true,
  });

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
                  color: _status[logLed] ? onColor : offColor,
                  iconSize: 100.0,
                  onPressed: () {
                    _changeSwitchStatus(logLed);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  color: _status[wifiLed] ? onColor : offColor,
                  iconSize: 100.0,
                  onPressed: () {
                    _changeSwitchStatus(wifiLed);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  color: _status[primarySwitch] ? onColor : offColor,
                  iconSize: 100.0,
                  onPressed: () {
                    _changeSwitchStatus(primarySwitch);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _status[logLed] ? Text("已经开启") : Text("已经关闭"),
                _status[wifiLed] ? Text("已经开启") : Text("已经关闭"),
                _status[primarySwitch] ? Text("已经开启") : Text("已经关闭"),
              ],
            )
          ]),
    );
  }

  _getCurrentStatus() async {
    String url =
        "http://${Config.webgRpcIp}:${widget.device.portConfig.localProt}/status";
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
//    同步状态到界面
    if (response.statusCode == 200) {
      setState(() {
//    log灯的状态
        if (jsonDecode(response.body)["logLed"] == 1) {
          _status[logLed] = false;
        } else {
          _status[logLed] = true;
        }
//    wifi灯的状态
        if (jsonDecode(response.body)["wifiLed"] == 1) {
          _status[wifiLed] = false;
        } else {
          _status[wifiLed] = true;
        }
//    总开关的状态
        if (jsonDecode(response.body)["primarySwitch"] == 1) {
          _status[primarySwitch] = false;
        } else {
          _status[primarySwitch] = true;
        }
      });
    } else {
      print("获取状态失败！");
    }
  }

  _setting() async {
    // TODO 设备设置
    TextEditingController _name_controller = TextEditingController.fromValue(
        TextEditingValue(text: widget.device.info["name"]));
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
                      try {
                        String url =
                            "http://${Config.webgRpcIp}:${widget.device.portConfig.localProt}/rename?name=${_name_controller.text}";
                        http.get(url).timeout(const Duration(seconds: 2));
                      } catch (e) {
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
    _result.add("设备名称:${widget.device.info["name"]}");
    _result.add("设备型号:${widget.device.info["model"]}");
    _result.add("物理地址:${widget.device.info["mac"]}");
    _result.add("id:${widget.device.info["id"]}");
    _result.add("支持的界面:${widget.device.info["ui-support"]}");
    _result.add("首选界面:${widget.device.info["ui-first"]}");
    _result.add("固件作者:${widget.device.info["author"]}");
    _result.add("邮件:${widget.device.info["email"]}");
    _result.add("主页:${widget.device.info["home-page"]}");
    _result.add("固件程序:${widget.device.info["firmware-respository"]}");
    _result.add("固件版本:${widget.device.info["firmware-version"]}");
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

  _changeSwitchStatus(String name) async {
    String url;
    if (_status[name]) {
      url =
          "http://${Config.webgRpcIp}:${widget.device.portConfig.localProt}/led?pin=OFF$name";
    } else {
      url =
          "http://${Config.webgRpcIp}:${widget.device.portConfig.localProt}/led?pin=ON$name";
    }
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
    _getCurrentStatus();
  }

}
