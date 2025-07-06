//PhicommTC1A1Plugin:https://github.com/iotdevice/phicomm_dc1
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:openiothub_plugin/utils/ip.dart';

import '../../../../models/PortServiceInfo.dart';

class PhicommTC1A1PluginPage extends StatefulWidget {
  PhicommTC1A1PluginPage({required Key key, required this.device})
      : super(key: key);

  static final String modelName = "com.iotserv.devices.phicomm_tc1_a1";
  final PortServiceInfo device;

  @override
  _PhicommTC1A1PluginPageState createState() => _PhicommTC1A1PluginPageState();
}

class _PhicommTC1A1PluginPageState extends State<PhicommTC1A1PluginPage> {
  static const String slot0 = "slot0";
  static const String slot1 = "slot1";

  static const String slot2 = "slot2";
  static const String slot3 = "slot3";
  static const String slot4 = "slot4";
  static const String slot5 = "slot5";

  static const String power = "power";

//  bool _logLedStatus = true;
//  bool _wifiLedStatus = true;
//  bool _primarySwitchStatus = true;
  Map<String, dynamic> _status = Map.from({
    slot0: true,
    slot1: true,
    slot2: true,
    slot3: true,
    slot4: true,
    slot5: true,
    power: 0.0,
  });

  Map<String, String> _realName = Map.from({
//    TODO 总开关
    slot0: "Switch 1",
    slot1: "Switch 2",
    slot2: "Switch 3",
    slot3: "Switch 4",
    slot4: "Switch 5",
    slot5: "Switch 6",
    power: "Power",
  });

  List<String> _switchKeyList = [slot0, slot1, slot2, slot3, slot4, slot5];
  List<String> _valueKeyList = [power];

  @override
  void initState() {
    super.initState();
    _getCurrentStatus();
    print("init iot devie List");
  }

  @override
  Widget build(BuildContext context) {
    final List _result = [];
    _result.addAll(_switchKeyList);
    _result.addAll(_valueKeyList);
    final tiles = _result.map(
      (pair) {
        switch (pair) {
          case slot0:
          case slot1:
          case slot2:
          case slot3:
          case slot4:
          case slot5:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]!),
                  Switch(
                    onChanged: (_) {
                      _status[pair] = !_status[pair];
                      _changeSwitchStatus();
                    },
                    value: _status[pair],
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
            );
            break;
          default:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]!),
                  Text(":"),
                  Text(_status[pair].toString()),
                  Text("W"),
                ],
              ),
            );
            break;
        }
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.info!["name"]!),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {
                _getCurrentStatus();
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
      body: ListView(children: divided),
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
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/status'))
          .timeout(const Duration(seconds: 6));
    } catch (e) {
      print(e.toString());
      return;
    }
    print("response.body:${response.body}");
    print("response.status:${response.statusCode}");
//    同步状态到界面
    if (response.statusCode == 200) {
      _switchKeyList.forEach((switchValue) {
        setState(() {
          _status[switchValue] =
              jsonDecode(response.body)[switchValue] == 1 ? true : false;
        });
      });
      _valueKeyList.forEach((value) {
        setState(() {
          _status[value] = jsonDecode(response.body)[value];
        });
      });
    } else {
      print("获取状态失败！");
    }
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
    String url =
        "http://${widget.device.addr}:${widget.device.port}/switch?$slot0=${_status[slot0] ? 1 : 0}&$slot1=${_status[slot1] ? 1 : 0}&$slot2=${_status[slot2] ? 1 : 0}&$slot3=${_status[slot3] ? 1 : 0}&$slot4=${_status[slot4] ? 1 : 0}&$slot5=${_status[slot5] ? 1 : 0}";
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await get_ip_by_domain(widget.device.addr)
                  : widget.device.addr,
              port: widget.device.port,
              path: '/switch',
              queryParameters: {
                slot0: _status[slot0] ? 1 : 0,
                slot1: _status[slot1] ? 1 : 0,
                slot2: _status[slot2] ? 1 : 0,
                slot3: _status[slot3] ? 1 : 0,
                slot4: _status[slot4] ? 1 : 0,
                slot5: _status[slot5] ? 1 : 0,
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
