//PhicommTC1A1Plugin:https://github.com/iotdevice/phicomm_dc1
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub/plugin/openiothub_plugin.dart';
import 'package:openiothub/plugin/utils/ip.dart';

import 'package:openiothub/plugin/models/port_service_info.dart';

class PhicommTC1A1PluginPage extends StatefulWidget {
  const PhicommTC1A1PluginPage({required Key key, required this.device})
      : super(key: key);

  static final String modelName = "com.iotserv.devices.phicomm_tc1_a1";
  final PortServiceInfo device;

  @override
  State<PhicommTC1A1PluginPage> createState() => PhicommTC1A1PluginPageState();
}

class PhicommTC1A1PluginPageState extends State<PhicommTC1A1PluginPage> {
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
  final Map<String, dynamic> _status = Map.from({
    slot0: true,
    slot1: true,
    slot2: true,
    slot3: true,
    slot4: true,
    slot5: true,
    power: 0.0,
  });

  final List<String> _switchKeyList = [slot0, slot1, slot2, slot3, slot4, slot5];
  final List<String> _valueKeyList = [power];

  @override
  void initState() {
    super.initState();
    _getCurrentStatus();
    debugPrint("init iot device list");
  }

  String _labelForOutlet(String key, OpenIoTHubLocalizations l10n) {
    final i = _switchKeyList.indexOf(key);
    if (i >= 0) {
      return l10n.smart_device_switch_n(i + 1);
    }
    if (key == power) {
      return l10n.smart_device_power;
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = OpenIoTHubLocalizations.of(context);
    final List result = [];
    result.addAll(_switchKeyList);
    result.addAll(_valueKeyList);
    final tiles = result.map(
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
                  Text(_labelForOutlet(pair as String, l10n)),
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
          default:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_labelForOutlet(pair as String, l10n)),
                  Text(":"),
                  Text(_status[pair].toString()),
                  Text(l10n.unit_watt),
                ],
              ),
            );
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
          .timeout(const Duration(seconds: 6));
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
    debugPrint("response.body:${response.body}");
    debugPrint("response.status:${response.statusCode}");
//    同步状态到界面
    if (response.statusCode == 200) {
      for (var switchValue in _switchKeyList) {
        setState(() {
          _status[switchValue] =
              jsonDecode(response.body)[switchValue] == 1 ? true : false;
        });
      }
      for (var value in _valueKeyList) {
        setState(() {
          _status[value] = jsonDecode(response.body)[value];
        });
      }
    } else {
      debugPrint("获取状态失败！");
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
    http.Response response;
    try {
      response = await http
          .get(Uri(
              scheme: 'http',
              host: widget.device.addr.endsWith(".local")
                  ? await getIpByDomain(widget.device.addr)
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
      debugPrint(response.body);
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
    _getCurrentStatus();
  }
}
