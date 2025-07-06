//PhicommDC1Plugin:https://github.com/iotdevice/phicomm_dc1
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pbgrpc.dart';
import 'package:openiothub_plugin/openiothub_plugin.dart';
import 'package:openiothub_plugin/utils/ip.dart';

import '../../../../models/PortServiceInfo.dart';

class PhicommDC1PluginPage extends StatefulWidget {
  PhicommDC1PluginPage({required Key key, required this.device})
      : super(key: key);

  static final String modelName = "com.iotserv.devices.phicomm_dc1";
  final PortServiceInfo device;

  @override
  _PhicommDC1PluginPageState createState() => _PhicommDC1PluginPageState();
}

class _PhicommDC1PluginPageState extends State<PhicommDC1PluginPage> {
  static const String logLed = "logLed";
  static const String wifiLed = "wifiLed";

  static const String plugin4 = "plugin4";
  static const String plugin5 = "plugin5";
  static const String plugin6 = "plugin6";

  //  总开关
  static const String plugin7 = "plugin7";

  static const String Voltage = "Voltage";
  static const String Current = "Current";
  static const String ActivePower = "ActivePower";
  static const String ApparentPower = "ApparentPower";
  static const String ReactivePower = "ReactivePower";
  static const String PowerFactor = "PowerFactor";
  static const String Energy = "Energy";

  List<String> _switchKeyList = [
    logLed,
    wifiLed,
    plugin7,
    plugin6,
    plugin5,
    plugin4
  ];
  List<String> _valueKeyList = [
    Voltage,
    Current,
    ActivePower,
    ApparentPower,
    ReactivePower,
    PowerFactor,
    Energy
  ];

//  bool _logLedStatus = true;
//  bool _wifiLedStatus = true;
//  bool _primarySwitchStatus = true;
  Map<String, dynamic> _status = Map.from({
    logLed: true,
    wifiLed: true,
    plugin4: true,
    plugin5: true,
    plugin6: true,
    plugin7: true,
    Voltage: 0.0,
    Current: 0.0,
    ActivePower: 0.0,
    ApparentPower: 0.0,
    ReactivePower: 0.0,
    PowerFactor: 0.0,
    Energy: 0.0,
  });

  Map<String, String> _realName = Map.from({
    logLed: "Logo灯",
    wifiLed: "WIFI灯",
    plugin7: "总开关",
    plugin6: "第一个插口",
    plugin5: "第二个插口",
    plugin4: "第三个插口",
    Voltage: "电压",
    Current: "电流",
    ActivePower: "有功功率",
    ApparentPower: "视在功率",
    ReactivePower: "无功功率",
    PowerFactor: "功率因数",
    Energy: "用电量",
  });

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
          case logLed:
          case plugin7:
          case wifiLed:
          case plugin6:
          case plugin5:
          case plugin4:
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_realName[pair]!),
                  Switch(
                    onChanged: (_) {
                      _changeSwitchStatus(pair);
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
                Icons.settings,
                // color: Colors.white,
              ),
              onPressed: () {
                _setting();
              }),
          IconButton(
              icon: Icon(
                Icons.file_upload,
                // color: Colors.white,
              ),
              onPressed: () {
                _ota();
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
            path: '/status',
          ))
          .timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
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

  _setting() async {
    // TODO 设备设置
    TextEditingController _name_controller = TextEditingController.fromValue(
        TextEditingValue(text: widget.device.info!["name"]!));
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
                    "${OpenIoTHubPluginLocalizations.of(context).setting_name}："),
                content: SizedBox.expand(
                    child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _name_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText:
                            OpenIoTHubPluginLocalizations.of(context).name,
                      ),
                    )
                  ],
                )),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text(OpenIoTHubPluginLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child:
                        Text(OpenIoTHubPluginLocalizations.of(context).modify),
                    onPressed: () async {
                      try {
                        String url =
                            "http://${widget.device.addr}:${widget.device.port}/rename?name=${_name_controller.text}";
                        http
                            .get(Uri.parse(url))
                            .timeout(const Duration(seconds: 2))
                            .then((_) {
                          setState(() {
                            widget.device.info!["name"] = _name_controller.text;
                          });
                        });
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

  _ota() async {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
                    "${OpenIoTHubPluginLocalizations.of(context).upgrade_firmware}："),
                content: SizedBox.expand(
                    child: UploadOTAPage(
                  url:
                      "http://${widget.device.addr}:${widget.device.port}/update",
                  key: UniqueKey(),
                )),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text(OpenIoTHubPluginLocalizations.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]));
  }

  _changeSwitchStatus(String name) async {
    String url;
    if (_status[name]) {
      url = "http://${widget.device.addr}:${widget.device.port}/switch?off=$name";
    } else {
      url = "http://${widget.device.addr}:${widget.device.port}/switch?on=$name";
    }
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
              queryParameters: _status[name] ? {"off": name} : {"on": name}))
          .timeout(const Duration(seconds: 2));
      print(response.body);
    } catch (e) {
      print(e.toString());
      return;
    }
    _getCurrentStatus();
  }
}
