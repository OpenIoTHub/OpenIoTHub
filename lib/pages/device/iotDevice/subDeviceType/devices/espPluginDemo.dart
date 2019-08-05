import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:android_intent/android_intent.dart';
import 'package:nat_explorer/pages/device/iotDevice/iotDevice.dart';

class EspPluginDemoPage extends StatefulWidget {
  EspPluginDemoPage({Key key, this.device}) : super(key: key);

  final IoTDevice device;

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
              children: <Widget>[ledBottonStatus?Text("已经开启"):Text("已经关闭"),],
            )
          ]),
    );
  }

  _getCurrentStatus() async {}

  _setting() async {}

  _changeSwitchStatus() async {
    setState(() {
      ledBottonStatus = !ledBottonStatus;
    });
  }

  _launchURL(String url) async {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    await intent.launch();
  }
}
