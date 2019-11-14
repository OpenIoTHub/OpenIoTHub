//oneKeySwitch:https://github.com/iotdevice/esp8266-switch
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:android_intent/android_intent.dart';
import 'package:nat_explorer/constants/Config.dart';
import '../../../model/portService.dart';
import '../commWidgets/info.dart';
import '../commWidgets/uploadOTA.dart';

class OneKeySwitchPage extends StatefulWidget {
  OneKeySwitchPage({Key key, this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.one-key-switch";
  final PortService device;

  @override
  _OneKeySwitchPageState createState() => _OneKeySwitchPageState();
}

class _OneKeySwitchPageState extends State<OneKeySwitchPage> {
  static const Color onColor = Colors.green;
  static const Color offColor = Colors.red;
  String ledBottonStatus = "off";

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
                  color: ledBottonStatus == "on" ? onColor : offColor,
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
                ledBottonStatus == "on" ? Text("已经开启") : Text("已经关闭"),
              ],
            )
          ]),
    );
  }

  _getCurrentStatus() async {
    String url = "http://${widget.device.ip}:${widget.device.port}/status";
    http.Response response;
    try {
      response = await http.get(url).timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
    if (response.statusCode == 200) {
      setState(() {
        ledBottonStatus = jsonDecode(response.body)["led"];
      });
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
                            "http://${widget.device.ip}:${widget.device.port}/rename?name=${_name_controller.text}";
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
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return InfoPage(
            portService: widget.device,
          );
        },
      ),
    );
  }

  _changeSwitchStatus() async {
    String url;
    url =
        "http://${widget.device.ip}:${widget.device.port}/led?status=${ledBottonStatus == "on" ? "off" : "on"}";
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
