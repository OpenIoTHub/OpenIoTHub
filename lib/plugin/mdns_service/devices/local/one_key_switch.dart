//oneKeySwitch:https://github.com/iotdevice/esp8266-switch
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub/plugin/openiothub_plugin.dart';
import 'package:openiothub/plugin/utils/ip.dart';

import 'package:openiothub/plugin/models/port_service_info.dart';

class OneKeySwitchPage extends StatefulWidget {
  OneKeySwitchPage({required Key key, required this.device}) : super(key: key);

  static final String modelName = "com.iotserv.devices.one-key-switch";
  final PortServiceInfo device;

  @override
  _OneKeySwitchPageState createState() => _OneKeySwitchPageState();
}

class _OneKeySwitchPageState extends State<OneKeySwitchPage> {
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
        title: Text(OpenIoTHubLocalizations.of(context).switch_control),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                // color: Colors.white,
              ),
              onPressed: () {
                _setting();
              }),
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
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  color: ledBottonStatus == "on" ? Colors.green : Colors.red,
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
                ledBottonStatus == "on"
                    ? Text(OpenIoTHubLocalizations.of(context).on)
                    : Text(OpenIoTHubLocalizations.of(context).off),
              ],
            )
          ]),
    );
  }

  _getCurrentStatus() async {
    String url = "http://${widget.device.addr}:${widget.device.port}/status";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await getIpByDomain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/status'))
          .timeout(const Duration(seconds: 2));
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
    TextEditingController _nameController = TextEditingController.fromValue(
        TextEditingValue(text: widget.device.info!["name"]!));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
                    "${OpenIoTHubLocalizations.of(context).setting_name}："),
                content: SizedBox.expand(
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText:
                              OpenIoTHubLocalizations.of(context).name,
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text(OpenIoTHubLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child:
                        Text(OpenIoTHubLocalizations.of(context).modify),
                    onPressed: () async {
                      try {
                        String url =
                            "http://${widget.device.addr}:${widget.device.port}/rename?name=${_nameController.text}";
                        http
                            .get(Uri(
                            scheme: 'http',
                            host: widget.device.addr.endsWith(".local")
                                ? await getIpByDomain(widget.device.addr)
                                : widget.device.addr,
                            port: widget.device.port,
                            path: '/rename',
                            queryParameters: {
                              "name": _nameController.text
                            }))
                            .timeout(const Duration(seconds: 2));
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
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  _changeSwitchStatus() async {
    String url;
    url =
        "http://${widget.device.addr}:${widget.device.port}/led?status=${ledBottonStatus == "on" ? "off" : "on"}";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await getIpByDomain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/led',
              queryParameters: {
                "status": ledBottonStatus == "on" ? "off" : "on"
              }))
          .timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
    _getCurrentStatus();
  }
}
